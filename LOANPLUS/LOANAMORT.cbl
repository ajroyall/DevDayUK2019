       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOANAMORT.
       REMARKS. THIS PROGRAM CALCULATES A MONTHLY PAYMENT SCHEDULE AMOUNT BASED
               TERM, PRINCIPAL, AND INTEREST RATE. 

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       77  PRINCIPAL-MAX             PIC S9(8) COMP-3 VALUE 999999.
       77  PRINCIPAL-MIN             PIC S9(8) COMP-3 VALUE 000001.
       77  LOANTERM-MAX              PIC S9(8) COMP-3 VALUE 000479.
       77  LOANTERM-MIN              PIC S9(8) COMP-3 VALUE 000001.
       77  RATE-MAX                  PIC S9(9)V9(9)   VALUE 99.99.
       77  RATE-MIN                  PIC S9(9)V9(9)   VALUE 00.00.

       01  INPUT-ERROR-FLAG          PIC X  VALUE "N".
           88  INPUT-ERROR     VALUE "Y".
           88  INPUT-GOOD      VALUE "N".

       01  MONTH                     PIC S9(4) COMP.
              
       01 DECPAYMENT PIC S9(9)V9(9) COMP-3.
       01 INTPAID    PIC S9(9)V9(9).
       01 TOTINTPAID PIC S9(9)V9(9).
       01 PRINCPAID  PIC S9(8)V99 COMP-3.

       01 WORK-FIELDS.
          03 WRK-MESSAGE         PIC X(40) VALUE "CALCULATING PAYMENT".
          03 WRK-RATE            PIC S9(9)V9(9) COMP-3.
          03 WRK-PAYMENT         PIC S9(9)V9(9) COMP-3.
          03 WRK-PAYMENT-A       PIC $$,$$$.99.
       
       LINKAGE SECTION.
       01 COPY AMORTIN.
       01 COPY AMORTOUT.
       PROCEDURE DIVISION USING LOANINFO
                                OUTDATA.

       0000-CONTROL SECTION.
           PERFORM 0110-VALIDATE-INPUT
           IF INPUT-ERROR
      *        INITIALIZE OUTDATA ALL TO VALUE
               IF OUTDATA = SPACES
                   move "ERROR 9001" to OUTDATA
               END-IF
               go to 0000-CONTROL-EXIT
           END-IF

           PERFORM 0100-CALC-PAYMENT
           MOVE WRK-PAYMENT TO DECPAYMENT
           
           PERFORM VARYING MONTH FROM 1 BY 1 UNTIL MONTH > LOANTERM
               COMPUTE INTPAID ROUNDED = PRINCIPAL * ((RATE / 100) /12)
               COMPUTE TOTINTPAID = TOTINTPAID + INTPAID

               IF MONTH = LOANTERM
                   COMPUTE DECPAYMENT = INTPAID + PRINCIPAL
               END-IF    
               
               COMPUTE PRINCPAID = DECPAYMENT - INTPAID
               COMPUTE PRINCIPAL ROUNDED = PRINCIPAL - PRINCPAID
               MOVE PRINCPAID   TO OUTPRINCPAID(MONTH)
               MOVE INTPAID     TO OUTINTPAID(MONTH)
               MOVE DECPAYMENT  TO OUTPAYMENT(MONTH)
               MOVE PRINCIPAL   TO OUTBALANCE(MONTH)
               
           END-PERFORM
           MOVE TOTINTPAID TO         OUTTOTINTPAID

           GOBACK.

       0000-CONTROL-EXIT.
           EXIT.
           goback.

       0100-CALC-PAYMENT SECTION.
           IF RATE = ZERO
               COMPUTE WRK-PAYMENT ROUNDED = PRINCIPAL / LOANTERM
           ELSE
               COMPUTE WRK-RATE = (RATE / 100) / 12
               COMPUTE WRK-PAYMENT  ROUNDED = (PRINCIPAL * WRK-RATE) /
                    (1 - (1 / ((1 + WRK-RATE) ** (LOANTERM))))
           END-IF.

       0100-CALC-PAYMENT-EXIT.
           EXIT.

      *************************************************************
      *    Validate the input values prior to calculations
      *    03 PRINCIPAL              PIC S9(8) COMP-3.
      *    03 LOANTERM               PIC S9(8) COMP-3.
      *    03 RATE                   PIC S9(9)V9(9).
       0110-VALIDATE-INPUT SECTION.
           IF PRINCIPAL > PRINCIPAL-MAX
               OR
              PRINCIPAL < PRINCIPAL-MIN
                   MOVE "ERROR PRINCIPAL 0-999,999"  TO  OUTDATA
                   MOVE "Y"                TO  INPUT-ERROR-FLAG
               *> TODO ERROR HERE
           END-IF

           IF LOANTERM > LOANTERM-MAX
               OR
              LOANTERM < LOANTERM-MIN
               *> TODO ERROR HERE
                   MOVE "ERROR LOAN TERM 1-479"  TO  OUTDATA
                   MOVE "Y"                TO  INPUT-ERROR-FLAG
           END-IF

           IF RATE > RATE-MAX
               OR
              RATE < RATE-MIN
               *> TODO ERROR HERE
                   MOVE "ERROR RATE 0-99.99"   TO  OUTDATA
                   MOVE "Y"            TO  INPUT-ERROR-FLAG
           END-IF
           
           .
       0110-CONTROL-EXIT.
           EXIT.

          
       END PROGRAM.
