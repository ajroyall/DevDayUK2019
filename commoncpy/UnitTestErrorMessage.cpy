           IF OUTDATA[0:5] NOT = "ERROR"
               GOBACK RETURNING MFU-PASS-RETURN-CODE
           ELSE
               DISPLAY "An Error has occured"
               EXHIBIT NAMED OUTDATA
               GOBACK RETURNING MFU-FAIL-RETURN-CODE
           END-IF
       .

