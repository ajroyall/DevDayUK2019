       copy "mfunit_prototypes.cpy".
       
       identification division.
       program-id. LoanPlusTest.

       data division.
       working-storage section.
       78 TEST-MAXPAYMENT   value "TestMaxPayment".
       78 TEST-MINPAYMENT   value "TestMinPayment".
       78 TEST-MAXTERM      value "TestMaxTerm".
       78 TEST-MINTERM      value "TestMinTerm".
       78 TEST-MAXRATE      value "LoanMaxRate".
       78 TEST-MINRATE      value "LoanMinRate".
       78 TEST-LoanPlusTest value "LoanPlusTest".
       copy "mfunit.cpy".

       COPY AMORTIN.
       COPY AMORTOUT.

       procedure division.
           goback returning 0
       .

       entry MFU-TC-PREFIX & TEST-LoanPlusTest.
           *> Test code goes here.
           MOVE 10000 TO PRINCIPAL
           MOVE 24 to LOANTERM
           MOVE 2.5 to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           IF OUTDATA NOT = "9001"
               GOBACK RETURNING MFU-PASS-RETURN-CODE
           ELSE
               DISPLAY "Oh Fuck, an error"
               EXHIBIT NAMED OUTDATA
               GOBACK RETURNING MFU-FAIL-RETURN-CODE
           END-IF
       .
           copy "UnitTestErrorMessage.cpy".
           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & TEST-MaxPayment.
           *> Test code goes here.
           MOVE 1000000    TO PRINCIPAL
           MOVE 24         to LOANTERM
           MOVE 2.5        to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           copy "UnitTestErrorMessage.cpy".

           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & TEST-MinPayment.
           *> Test code goes here.
           MOVE 0 TO PRINCIPAL
           MOVE 24 to LOANTERM
           MOVE 2.5 to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           copy "UnitTestErrorMessage.cpy".
           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & TEST-MaxTerm.
           *> Test code goes here.
           MOVE 10000 TO PRINCIPAL
           MOVE 480 to LOANTERM
           MOVE 2.5 to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           copy "UnitTestErrorMessage.cpy".

           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & TEST-MinTerm.
           *> Test code goes here.
           MOVE 10000 TO PRINCIPAL
           MOVE 0 to LOANTERM
           MOVE 2.5 to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           copy "UnitTestErrorMessage.cpy".

           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & TEST-MaxRate.
           *> Test code goes here.
           MOVE 10000 TO PRINCIPAL
           MOVE 24 to LOANTERM
           MOVE 100 to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           copy "UnitTestErrorMessage.cpy".

           goback returning MFU-PASS-RETURN-CODE
       .

       entry MFU-TC-PREFIX & TEST-MinRate.
           *> Test code goes here.
           MOVE 10000 TO PRINCIPAL
           MOVE 24 to LOANTERM
           MOVE -0.01 to RATE

           call "LOANAMORT" USING LOANINFO OUTDATA

           copy "UnitTestErrorMessage.cpy".

           goback returning MFU-PASS-RETURN-CODE
       .


       entry MFU-TC-SETUP-PREFIX & TEST-LoanPlusTest.
           goback returning 0
       .

       entry MFU-TC-TEARDOWN-PREFIX & TEST-LoanPlusTest.
           goback returning 0
       .

      $region Test Configuration

       entry MFU-TC-METADATA-SETUP-PREFIX & TEST-LoanPlusTest.
           move "This is a example of a dynamic description" to MFU-MD-TESTCASE-DESCRIPTION
           move 10000 to MFU-MD-TIMEOUT-IN-MS
           move "smoke,dynmeta" to MFU-MD-TRAITS
           set MFU-MD-SKIP-TESTCASE to false
           goback returning 0
       .

      $end-region

       end program.