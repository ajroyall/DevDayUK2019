       class-id AmortWPFClient.Window1 is partial
                 inherits type System.Windows.Window.

       working-storage section.
       method-id NEW.
       procedure division.
           invoke self::InitializeComponent()
           goback.
       end method.

       method-id btnAmort_Click.
       01 AmortURL             String value "http://localhost:7071/api/Function1?".
       01 apiURL               type Uri.
       01 wc                   type WebClient.
       01 jSer                 type DataContractJsonSerializer.
       01 result               type Byte occurs any.
       01 LoanDataObj          type LoanData.
       01 AmortList            List[type AmortData].
       
       procedure division using by value sender as object e as type System.Windows.RoutedEventArgs.
           declare P = tbPrincipal::Text
           declare T = tbMonths::Text
           declare R = tbRate::Text

           set AmortURL to AmortURL & "P=" & P & "&" & "T=" & T & "&" & "R=" & R
           set wc to new WebClient

           set result to wc::DownloadData(AmortURL)
      *    set result to wc::DownloadDataAsync(apiURL) *> Does not like the apiURL?

           declare ms = new MemoryStream(result)
           set jSer to new DataContractJsonSerializer(type of LoanData)
           set LoanDataObj to jSer::ReadObject(ms) as type LoanData
           
           set AmortList to LoanDataObj::AmortList
           set dgAmortData::ItemsSource to AmortList
           set lblTotInterest::Content to LoanDataObj::TotalInterest
           set lblInterest::Visibility to type Visibility::Visible
           
           goback.

       end method.

       method-id btnAPI_Click.
       01 apiURL               String value "api/Function1?".
       01 client               type HttpClient.
       01 response             string.
      *01 response             Byte occurs any.
       01  statusCode          string.
       01  errorText           string.
       01 jSer                 type DataContractJsonSerializer.
       01 result               type Byte occurs any.
       01 LoanDataObj          type LoanData.
       01 AmortList            List[type AmortData].
       
       procedure division using by value sender as object e as type System.Windows.RoutedEventArgs.
           declare P = tbPrincipal::Text
           declare T = tbMonths::Text
           declare R = tbRate::Text

           set client              to  new HttpClient
           set client::BaseAddress to  new Uri("https://loanamortfunctions20181220113647.azurewebsites.net")
           set apiURL  to apiURL & "P=" & P & "&" & "T=" & T & "&" & "R=" & R
           set response            to  client::PostAsync(apiURL, new StringContent(string::Empty))::Result
      *    set statusCode          to  response::StatusCode
      *    set errorCode           to  response::ReasonPhrase

      *    set result to wc::DownloadData(AmortURL)
      *    set result to response
           declare ms = new MemoryStream(result)
           set jSer to new DataContractJsonSerializer(type of LoanData)
           set LoanDataObj to jSer::ReadObject(ms) as type LoanData
           
           set AmortList to LoanDataObj::AmortList
           set dgAmortData::ItemsSource to AmortList
           set lblTotInterest::Content to LoanDataObj::TotalInterest
           set lblInterest::Visibility to type Visibility::Visible
           
           goback.

       end method.

       method-id btnAmortString_Click.
       01 AmortURL String value "http://localhost/AmortService/AmortService/amortstring?".
       01 wc type WebClient.
       01 jSer type DataContractJsonSerializer.
       01 result type Byte occurs any.
       01 LoanDataObj String.
       01 AmortList List[type AmortData].
       01 loanterm binary-long.
       01 payInfo type LoanData.
       
       01 outdata.
           03 Payments occurs 1 to 480 depending on loanterm.
               05 outIntPaid     pic $$,$$$.99.
               05 outPrincPaid   pic $$,$$$.99.
               05 outPayment     pic $$,$$$.99.
               05 outBalance     pic $$$,$$$.99.
           03 outTotIntPaid  pic $$,$$$.99.       
       
       procedure division using by value sender as object e as type System.Windows.RoutedEventArgs.
           declare P = tbPrincipal::Text
           declare T = tbMonths::Text
           declare R = tbRate::Text
           set loanterm to type Convert::ToInt32(T)           
           set AmortURL to AmortURL & "P=" & P & "&" & "T=" & T & "&" & "R=" & R
           set wc to new WebClient
           set result to wc::DownloadData(AmortURL)
           declare ms = new MemoryStream(result)
           set jSer to new DataContractJsonSerializer(type of String)
           set LoanDataObj to jSer::ReadObject(ms) as type String
           set outdata to type Convert::FromBase64String(LoanDataObj)
           
           set PayInfo to new type LoanData
           set AmortList to new List[type AmortData]
           declare currDate = type DateTime::Now
           if currDate::Day > 28
               declare daysAdjust = currDate::Day - 28
               set currDate to currDate::AddDays(daysAdjust * -1)
           end-if           
           perform varying Month as binary-long from 1 by 1 until Month > loanterm
               declare AmortObj = new AmortData
               declare payDate = currDate::AddMonths(Month)
               set AmortObj::PayDateNo     to "#" & Month & "    " & payDate::ToShortDateString
               set AmortObj::Balance       to outBalance(Month)
               set AmortObj::InterestPaid  to outIntPaid(Month)
               set AmortObj::PrincipalPaid to outPrincPaid(Month)
               set AmortObj::Payment       to outPayment(Month)
               invoke AmortList::Add(AmortObj)
           end-perform
           
           set PayInfo::AmortList to AmortList
           set PayInfo::TotalInterest to outTotIntPaid           
           set dgAmortData::ItemsSource to AmortList
           set lblTotInterest::Content to payInfo::TotalInterest
           set lblInterest::Visibility to type Visibility::Visible           
           
           goback.
       
       end method.

       class-id LoanData.
       01 AmortList      List[type AmortData] property.
       01 TotalInterest  String               property.
       end class.

       class-id AmortData.
       01 PayDateNo        String property.
       01 InterestPaid     String property.
       01 PrincipalPaid    String property.
       01 Payment          String property.
       01 Balance          String property.
       end class.

       end class.
       

