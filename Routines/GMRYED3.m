GMRYED3 ;HIRMFO/YH-START IV AND IV MAINTENANCE ENTRY POINT ;9/10/92
 ;;4.0;Intake/Output;;Apr 25, 1997
EN1 ;SELECTE IV I/O AND IV MAINTENANCE
 S (GMRVIDT,GDR,GMROUT)=0,GSITE="" D MASPT^GMRYRP5
LIST W ! S (GMROUT,GNN)=0,DA=DFN D LISTOP^GMRYED4
 W !!,"Select from 1 to ",GNN," (enter 1,3-5 etc.) or <RET> to exit: " R GNI:DTIME S:'$T!(GNI["^")!(GNI="") GMROUT=1 G:GMROUT Q
 I (GNI["?") W ! D LISTQUES^GMRYED4 W !!,"Enter <RET> to continue or ^ to exit " R X:DTIME S:'$T!(X["^")!(X="") GMROUT=1 G:GMROUT Q
 D VALIDAT^GMRYED1 I '$D(GTYP)!GMROUT(1) W $C(7),"  ??" G LIST
 S GGNN=0 F  S GGNN=$O(GTYP(GGNN)) Q:GGNN'>0  I $D(GNN(GGNN)) S GOPT=$P(GNN(GGNN),"^",2) D @GOPT I GMROUT S GMROUT=0 Q
Q K GPORT,X,Y,DD,DR,DIE,DIC,DLAYGO,%,GMRZZZ,GSAVE,GLINE,GMRX,GSAVE,GDCREAS,GIV,GMRDC,GMRVN,GIVDT,GREC,GSITE,GMRDA,GIN,GLEFT,GGDA,GMRY,GDCIV,GDCDT,DA,GDR,GDCIV,GADD,GGNN,GNN,GNI,GNUR,GOPT,GMRW,GTYP,GCT,GDATA,GMRXX,GMRZ,GNOW,GST G:GMROUT=0 LIST
 D Q^GMRYED2 K GFLAG,GHLOC,GMRVTYP,GMRYY,GCATH Q
 ;
STARTIV ;
 S GMROUT=0 W @IOF,!!,"*** START IV ***",! S GDCIV=0 D EN3^GMRYED1
 K GFLAG Q
 ;
DCIV ;REMOVE IV FROM IV SITE
 D DCIV^GMRYDCIV Q
 ;
MAINTN ;CARE/MAINTENANCE/FLUSH OPTION ENTRY POINT
 S GMROUT=0,GDCIV=4 W @IOF,!!,"*** CARE/MAINTENANCE/FLUSH ***",! D SELSITE^GMRYMNT W:GMRXY=0 !!,"There are no sites with IV(s) running or DC'd within 24 hours.",! D:GMRXY>0 EN1^GMRYMNT K GSTDC,GST,GCT,GX,GMRXY Q
 ;
HANG ;D/C CURRENT SOLUTION/ADD THE SAME SOLUTION
 S GMROUT=0,DA=DFN,GDCIV=5,GMRDC=0 W @IOF,!!,"*** REPLACE SAME SOLUTION ***",! D LISTIV^GMRYUT0,SEL^GMRYED4 Q:X=""  I GMROUT D Q4^GMRYED6 Q
 S GDR=0 I $G(GCATH)'="" S GCATH(2)=$S($D(^GMRD(126.74,"B",GCATH)):$O(^GMRD(126.74,"B",GCATH,0)),1:"")
 D HANG^GMRYED4 D Q4^GMRYED6 Q
 ;
ADDONLY ;ADD ANOTHER SOLUTION (MULTIPLE SOLUTIONS FOR A LINE) WITHOUT DC CURRENT
 S GDCIV=6,DA=DFN,(GMROUT,GMRDC)=0 W @IOF,!!,"*** ADD ADDITIONAL SOLUTION(S) ***",!! D SELSITE^GMRYMNT,SEL1^GMRYMNT Q:GMROUT!(GMRXY=0)!(X="")  D DT^GMRYUT3 Q:GMROUT!(GX'>0)
 ;ONLY ONE INFUSION SITE
 I GMRXY=1 W !,GSITE(GSITE) D SITEIV
 S GMROUT(1)=0,GMROUT(1)=$$ADM^GMRYUT12(.GMROUT,DFN,GX) Q:GMROUT
 S GMRLINE=0
SELECTP G:GMROUT QADD I GMRLINE>0,'$D(GMRPORT) G QADD
 ;OBTAIN PORT/LUMEN
 K GHOLD S GCATH=GSITE(GSITE),GCATH(1)="",GCATH(2)=$O(^GMRD(126.74,"B",GCATH,0)) S GHOLD=GCATH(2),(GHOLD(1),GHOLD(2),GHOLD(3))="" D FINDPORT^GMRYSTCA(.GHOLD) S GCATH(1)=GHOLD(3) I GMROUT K GX,GHOLD G QADD
 K GHOLD S GMRLINE=0 D SOLTYPE^GMRYUT7 I 'GMROUT S GMRDEL="",GDR=3,GADD="Y" D ADDIV^GMRYED2 G SELECTP
QADD D Q4^GMRYED6 K GST,GCT,GSDC,GMRLINE Q
 Q
 ;
ADDSOL ;ADD IV SOLUTION
 W @IOF,!!,"*** SOLUTION: REPLACE/DC/CONVERT/FINISH SOLUTION ***",! S GDCIV=0,GDCREAS=0
 D ADDSOL1^GMRYED6 K GST,GCT,GDCDT,GDCREAS,%
 Q
TITER ;ADJUST INFUSION RATE FOR A SELECTED SOLUTION
 D INFUSE^GMRYINFS Q
 ;
FLUSH ;FLUSH OPTION ENTRY POINT
 D FLUSH^GMRYFLSH Q
 ;
RESTART ;RESTAT AN IV
 W @IOF,!!,"*** RESTART DC'd IV ***" S (GMROUT,GDCIV)=0 D RESTART^GMRYUT10
 Q
SITEIV ;
 S GDA="" F  S GDA=$O(GST(GSITE,GDA)) Q:GDA=""  W:GDA'="BLANK" !,?2,GDA S GPORT=GDA,GDA(1)=0 F  S GDA(1)=$O(GST(GSITE,GDA,GDA(1))) Q:GDA(1)'>0  S GDATA=GST(GSITE,GDA,GDA(1),0) D WRITE^GMRYMNT
 Q