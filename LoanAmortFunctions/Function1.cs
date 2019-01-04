using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using MicroFocus.COBOL.RuntimeServices.Generic;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;

namespace LoanAmortFunctions
{
    public static class Function1
    {
        [FunctionName("Function1")]
        public static HttpResponseMessage Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)]
           // [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)]
            LoanParameters loanParameters,
            HttpRequestMessage req,
            TraceWriter log)
        {
            log.Info("C# HTTP trigger function processed a request.");

            if (!loanParameters.Validate())
            {
                return req.CreateErrorResponse(HttpStatusCode.BadRequest, String.Join(", ", loanParameters.Errors));
            }

            var loanData = CallLoanAmort(loanParameters, log);

            if(loanData == null)
            {
                return req.CreateErrorResponse(HttpStatusCode.BadRequest, "Failed to get loan term");
            }
            else
            {
                return req.CreateResponse(HttpStatusCode.OK, loanData, JsonMediaTypeFormatter.DefaultMediaType);
            }
        }

        private static LoanData CallLoanAmort(LoanParameters parameters, TraceWriter log)
        {
            // Map the parameters to the SmartLinkage input
            var loanInfo = new Loaninfo()
            {
                Loanterm = parameters.T,
                Principal = parameters.P,
                Rate = parameters.R
            };

            var outData = new Outdata();

            try
            {
                using (var runUnit = new RunUnit<LOANAMORT>())
                {
                    runUnit.Call(nameof(LOANAMORT), loanInfo.Reference, outData.Reference);
                }
            }
            catch(Exception ex)
            {
                log.Error("LOANAMORT run unit call failed", ex);
                return null;
            }

            var date = DateTime.Now;
            if(date.Day > 28)
            {
                var daysToAdjust = (date.Day - 28) * -1;
                date = date.AddDays(daysToAdjust);
            }

            var loanData = new LoanData();
            loanData.TotalInterest = outData.Outtotintpaid;

            for(int i = 0; i < loanInfo.Loanterm; i++)
            {
                var loanPayment = new AmortData()
                {
                    PayDateNo = string.Format("#{0} {1}", i, date.AddMonths(i+1).ToShortDateString()),
                    Payment = outData.get_Outpayment(i),
                    InterestPaid = outData.get_Outintpaid(i),
                    PrincipalPaid = outData.get_Outprincpaid(i),
                    Balance = outData.get_Outbalance(i)
                };
                loanData.AmortList.Add(loanPayment);
            }

            return loanData;
        }
    }
}
