       class-id CobList.
       
       working-storage section.
       copy "AmortIn.cpy".
	   copy "AmortOut.cpy".
       
       method-id AmortInfo (P as type Int32, T as binary-long, R as decimal)
           returning PaymentInfo as type LoanData.
       
       01 AmortList list[type AmortData].
       
           set PaymentInfo to new LoanData          
           set principal to P
           set LOANTERM  to T
           set RATE      to R

           try 
               perform using RunUnitInst as type RunUnit[type LOANAMORT] = new RunUnit[type LOANAMORT]
                   invoke RunUnitInst::Call("LOANAMORT", LOANINFO, OUTDATA)
               end-perform
           catch
               declare err = exception-object::Message
           end-try 

           declare currDate = type DateTime::Now
           if currDate::Day > 28
               declare daysAdjust = currDate::Day - 28
               set currDate to currDate::AddDays(daysAdjust * -1)
           end-if    
           set PaymentInfo::AmortList to new List[type AmortData]           
           perform varying Month as type Int32
               from 1 by 1 until Month > LOANTERM
       
               declare payDate = currDate::AddMonths(Month)
               declare adObject = new AmortData
               set adObject::PayDateNo     to "#" & Month & "    " & payDate::ToShortDateString
               set adObject::InterestPaid  to OUTINTPAID(Month)
               set adObject::PrincipalPaid to OUTPRINCPAID(Month)
               set adObject::Payment       to OUTPAYMENT(Month)
               set adObject::Balance       to OUTBALANCE(Month)
               invoke PaymentInfo::AmortList::Add(adObject)
               
           end-perform 
           set PaymentInfo::TotalInterest to OUTTOTINTPAID

       end method.

       end class.

       class-id LoanData.
       01 AmortList      List[type AmortData] property.
       01 TotalInterest  String               property.
       end class.
