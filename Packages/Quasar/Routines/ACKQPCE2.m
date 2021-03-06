ACKQPCE2 ; HCIOFO/AG - Quasar/PCE Interface - Error Processing; August 1999
 ;;3.0;QUASAR;;Feb 11, 2000
 Q
 ;
CONVERT(ACKPROB,ACKAPI,ACKRSN) ; convert the error array ACKPROB into a list of errors
 ;
 ; this label is called from the main Overnight Interface program
 ; ^ACKQPCE if the DATA2PCE^PXAPI returns any errors or warnings. 
 ; this routine will format the errors and place them in the local
 ; array ACKRSN. a separate call to label FILE will add them on the 
 ; database.
 ;
 ; requires ACKPROB - array generated by DATA2PCE^PXAPI
 ;          ACKAPI - global ref of encounter data passed in to DATA2PCE
 ;          .ACKRSN - (by reference) - the output array
 ;
 ; returns ACKRSN=n and ACKRSN(n)=text where each error is formatted 
 ;  to FIELD^INTERNAL VALUE^EXTERNAL VALUE^ERROR/WARNING MESSAGE
 ;  eg ACKRSN(1)="PRIMARY PROVIDER^1234^BLOGGS,FRED^The Provider...
 ;                      ...does not have an ACTIVE person class!
 ;
 N ACKI
 N ACKDEBUG S ACKDEBUG="CONVERT"
 K ACKRSN S ACKRSN=0
 F ACKI=1:1 Q:'$D(ACKPROB($J,ACKI))  D
 . I $D(ACKPROB($J,ACKI,"ERROR1")) D ERROR1
 . K ACKPROB($J,ACKI) ; only error1 messages are kept, all others ignored
 Q
 ;
ERROR1 ; process an Error 1
 N ACKMSG,ACKEXT,ACKINT,ACKNUM,ACKTYP,ACKFLD,ACKSUB
 ;
 ; check for error with visit date
 I $D(ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","ENC D/T",1)) D
 . S ACKINT=@ACKAPI@("ENCOUNTER",1,"ENC D/T")
 . S ACKEXT=$$DATETIME(ACKINT)
 . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","ENC D/T",1)
 . D ADDRSN("ENC D/T",ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . K ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","ENC D/T",1)
 ;
 ; check for error with patient
 I $D(ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","PATIENT",1)) D
 . S ACKINT=@ACKAPI@("ENCOUNTER",1,"PATIENT")
 . S ACKEXT=$$PATIENT(ACKINT)
 . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","PATIENT",1)
 . D ADDRSN("PATIENT",ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . K ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","PATIENT",1)
 ;
 ; check for error with clinic
 I $D(ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","HOS LOC",1)) D
 . S ACKINT=@ACKAPI@("ENCOUNTER",1,"HOS LOC")
 . S ACKEXT=$$CLINIC(ACKINT)
 . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","HOS LOC",1)
 . D ADDRSN("CLINIC",ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . K ACKPROB($J,ACKI,"ERROR1","ENCOUNTER","HOS LOC",1)
 ;
 ; check for any other "ENCOUNTER" errors
 S ACKFLD="" F  S ACKFLD=$O(ACKPROB($J,ACKI,"ERROR1","ENCOUNTER",ACKFLD)) Q:ACKFLD=""  D
 . I $D(ACKPROB($J,ACKI,"ERROR1","ENCOUNTER",ACKFLD,1))#10=0 Q
 . I $D(@ACKAPI@("ENCOUNTER",1,ACKFLD))#10=0 Q
 . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","ENCOUNTER",ACKFLD,1)
 . S ACKINT=@ACKAPI@("ENCOUNTER",1,ACKFLD)
 . D ADDRSN(ACKFLD,ACKINT,"",ACKMSG,.ACKRSN)
 . K ACKPROB($J,ACKI,"ERROR1","ENCOUNTER",ACKFLD,1)
 ;
 ; check for provider name errors
 I $D(ACKPROB($J,ACKI,"ERROR1","PROVIDER","NAME")) D
 . S ACKNUM="" F  S ACKNUM=$O(ACKPROB($J,ACKI,"ERROR1","PROVIDER","NAME",ACKNUM)) Q:ACKNUM=""  D
 . . S ACKINT=@ACKAPI@("PROVIDER",ACKNUM,"NAME")
 . . S ACKEXT=$$PRVNAME(ACKINT)
 . . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","PROVIDER","NAME",ACKNUM)
 . . S ACKFLD=$S($D(@ACKAPI@("PROVIDER",ACKNUM,"PRIMARY")):"PRIMARY ",1:"")_"PROVIDER"
 . . D ADDRSN(ACKFLD,ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . . K ACKPROB($J,ACKI,"ERROR1","PROVIDER","NAME",ACKNUM)
 ;
 ; check for Procedure code errors
 I $D(ACKPROB($J,ACKI,"ERROR1","PROCEDURE","PROCEDURE")) D
 . S ACKNUM="" F  S ACKNUM=$O(ACKPROB($J,ACKI,"ERROR1","PROCEDURE","PROCEDURE",ACKNUM)) Q:ACKNUM=""  D
 . . S ACKINT=@ACKAPI@("PROCEDURE",ACKNUM,"PROCEDURE")
 . . S ACKEXT=$$CPTNAME(ACKINT)
 . . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","PROCEDURE","PROCEDURE",ACKNUM)
 . . D ADDRSN("PROCEDURE",ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . . K ACKPROB($J,ACKI,"ERROR1","PROCEDURE","PROCEDURE",ACKNUM)
 ;
 ; check for Modifier errors 
 S ACKSUB="MODIFIER"
 F  S ACKSUB=$O(ACKPROB($J,ACKI,"ERROR1","PROCEDURE",ACKSUB)) Q:$E(ACKSUB,1,8)'="MODIFIER"  D
 . S ACKNUM="" F  S ACKNUM=$O(ACKPROB($J,ACKI,"ERROR1","PROCEDURE",ACKSUB,ACKNUM)) Q:ACKNUM=""  D
 . . S ACKINT="",ACKEXT=$P(ACKSUB,",",2)
 . . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","PROCEDURE",ACKSUB,ACKNUM)
 . . S ACKMSG=ACKMSG_" (Procedure="_$G(@ACKAPI@("PROCEDURE",ACKNUM,"PROCEDURE"))_")"
 . . D ADDRSN("MODIFIER",ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . . K ACKPROB($J,ACKI,"ERROR1","PROCEDURE",ACKSUB,ACKNUM)
 ;
 ; check for Diagnosis code errors
 I $D(ACKPROB($J,ACKI,"ERROR1","DX/PL","DIAGNOSIS")) D
 . S ACKNUM="" F  S ACKNUM=$O(ACKPROB($J,ACKI,"ERROR1","DX/PL","DIAGNOSIS",ACKNUM)) Q:ACKNUM=""  D
 . . S ACKINT=@ACKAPI@("DX/PL",ACKNUM,"DIAGNOSIS")
 . . S ACKEXT=$$ICDNAME(ACKINT)
 . . S ACKMSG=ACKPROB($J,ACKI,"ERROR1","DX/PL","DIAGNOSIS",ACKNUM)
 . . D ADDRSN("DIAGNOSIS",ACKINT,ACKEXT,ACKMSG,.ACKRSN)
 . . K ACKPROB($J,ACKI,"ERROR1","DX/PL","DIAGNOSIS",ACKNUM)
 ;
 ; check for any remaining errors not coded for
 S ACKTYP="" F  S ACKTYP=$O(ACKPROB($J,ACKI,"ERROR1",ACKTYP)) Q:ACKTYP=""  D
 . S ACKFLD="" F  S ACKFLD=$O(ACKPROB($J,ACKI,"ERROR1",ACKTYP,ACKFLD)) Q:ACKFLD=""  D
 . . S ACKNUM="" F  S ACKNUM=$O(ACKPROB($J,ACKI,"ERROR1",ACKTYP,ACKFLD,ACKNUM)) Q:ACKNUM=""  D
 . . . I $D(@ACKAPI@(ACKTYP,ACKNUM,ACKFLD))#10=0 Q
 . . . I $D(ACKPROB($J,ACKI,"ERROR1",ACKTYP,ACKFLD,ACKNUM))#10=0 Q
 . . . S ACKINT=@ACKAPI@(ACKTYP,ACKNUM,ACKFLD)
 . . . S ACKMSG=ACKPROB($J,ACKI,"ERROR1",ACKTYP,ACKFLD,ACKNUM)
 . . . D ADDRSN(ACKTYP_":"_ACKFLD,ACKINT,"",ACKMSG,.ACKRSN)
 . . . K ACKPROB($J,ACKI,"ERROR1",ACKTYP,ACKFLD,ACKNUM)
 ;
 ; end of processing errors
 Q
 ;
 ;
ADDRSN(FLD,INT,EXT,MSG,ACKRSN) ; add erorr to the output array
 I +$G(ACKRSN)=0 K ACKRSN S ACKRSN=0  ; if count=0 make sure array empty
 S ACKRSN=ACKRSN+1
 S $P(ACKRSN(ACKRSN,0),U,1)=ACKRSN ; error number
 S $P(ACKRSN(ACKRSN,0),U,2)=FLD ; field name
 S $P(ACKRSN(ACKRSN,0),U,3)=INT ; internal format
 S $P(ACKRSN(ACKRSN,0),U,4)=EXT ; external format
 S ACKRSN(ACKRSN,1)=MSG ; error message
 Q
PATIENT(ACKPAT) ; get patient name
 Q $$GET1^DIQ(509850.2,ACKPAT_",",.01,"E")
PRVNAME(ACKPRV) ; get provider name
 Q $$GET1^DIQ(200,ACKPRV_",",.01,"E")
CLINIC(ACKCLN) ; get clinic name
 Q $$GET1^DIQ(44,ACKCLN_",",.01,"E")
CPTNAME(ACKCPT) ; get CPT procedure name
 Q $$GET1^DIQ(509850.4,ACKCPT_",",.01,"E")
ICDNAME(ACKICD) ; get ICD diagnosis name
 Q $$GET1^DIQ(509850.1,ACKICD_",",.01,"E")
DATETIME(Y) ; convert date/time to external
 D DD^%DT
 Q Y
