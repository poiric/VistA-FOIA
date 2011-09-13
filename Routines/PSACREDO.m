PSACREDO ;BIR/JMB-Outstanding Credits ;7/23/97
 ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**3,16**; 10/24/97
 ;This routine prints detailed or summary outstanding credits report.
 ;
 ;References to ^PSDRUG( are covered by DBIA #2095
 ;PSA*3*16 (DAVE B) Changed PSADJQ=0 to PSADJQ=""
 ;
 I '$D(^XUSEC("PSA ORDERS",DUZ)) W !,"You do not hold the key to enter the option." Q
 I '$O(^PSD(58.811,"AC",1,0)) W !!,"There are no outstanding credit memos." Q
 S DIR(0)="S^D:Detailed Report;S:Summary Report",DIR("A")="Print a detailed or summary report",DIR("??")="^D RPT^PSACREDO" D ^DIR K DIR I $G(DIRUT) G EXIT
 S PSARPT=Y W:PSARPT="D" !!,"The report must be sent to a 132 column printer."
DEVICE W ! S %ZIS="Q" D ^%ZIS G:POP EXIT
 ;I PSARPT="D",$E(IOST,1,2)="C-" W !!,"The report must be sent to a 132 column printer." G DEVICE
 I $D(IO("Q")) D  G EXIT
 .S ZTDESC="Drug Acct. - Print Outstanding Credits",ZTRTN="DQ^PSACREDO"
 .S ZTSAVE("PSARPT")="" D ^%ZTLOAD
DQ S PSASLN="",$P(PSASLN,"-",80)="",PSALSLN="",$P(PSALSLN,"-",132)=""
 S (PSAGDF,PSA,PSAOUT,PSAPG)=0
 F  S PSA=+$O(^PSD(58.811,"AC",1,PSA)) Q:'PSA  D  Q:PSAOUT
 .Q:'$D(^PSD(58.811,PSA,0))
 .S PSAORD=$P(^PSD(58.811,PSA,0),"^"),(PSA1,PSAOECST,PSAODF)=0
 .F  S PSA1=+$O(^PSD(58.811,"AC",1,PSA,PSA1)) Q:'PSA1  D  Q:PSAOUT
 ..Q:'$D(^PSD(58.811,PSA,1,PSA1,0))
 ..S PSAINV=$P(^PSD(58.811,PSA,1,PSA1,0),"^"),(PSACRED,PSAAECST,PSAIECST)=0
 ..S PSA2=0 F  S PSA2=+$O(^PSD(58.811,PSA,1,PSA1,1,PSA2)) Q:'PSA2!(PSAOUT)  D  Q:PSAOUT
 ...Q:'$D(^PSD(58.811,PSA,1,PSA1,1,PSA2,0))
 ...S PSADATA=^PSD(58.811,PSA,1,PSA1,1,PSA2,0)
 ...D LINE
 ..D CREDITS S PSAODF=PSAODF+$G(PSADF),PSAOECST=PSAOECST+PSAAECST
 .S PSA(PSAORD)=$J(PSAOECST,$L($P(PSAOECST,".")),2)_"^"_$J(PSAODF,$L($P(PSAODF,".")),2)
 .S PSAGDF=PSAGDF+PSAODF
 ;
 S PSAORD="" F  S PSAORD=$O(PSA(PSAORD)) Q:PSAORD=""  S PSAINV="" F  S PSAINV=$O(^PSD(58.811,"AORD",PSAORD,PSAINV)) Q:PSAINV=""  D
 .Q:$D(PSA(PSAORD,PSAINV))  S (PSA,PSAAECST,PSAIECST)=0
 .F  S PSA=$O(^PSD(58.811,"AORD",PSAORD,PSAINV,PSA)) Q:'PSA  S PSA1=0 F  S PSA1=$O(^PSD(58.811,"AORD",PSAORD,PSAINV,PSA,PSA1)) Q:'PSA1  D
 ..D GETLINE
 ..I 'PSAAECST&(+PSAIECST) S $P(PSA(PSAORD),"^")=+$P(PSA(PSAORD),"^")+PSAIECST,$P(PSA(PSAORD),"^")=$J($P(PSA(PSAORD),"^"),$L($P($P(PSA(PSAORD),"^"),".")),2)
 ..I PSAAECST S $P(PSA(PSAORD),"^")=+$P(PSA(PSAORD),"^")+PSAAECST,$P(PSA(PSAORD),"^")=$J($P(PSA(PSAORD),"^"),$L($P($P(PSA(PSAORD),"^"),".")),2)
 D PRINT
 ;
EXIT D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" K IO("Q")
 K %ZIS,DIR,DIRUT,PSA,PSA1,PSA2,PSAACST,PSAAECST,PSAAVAL,PSAC,PSACRED,PSADATA,PSADF,PSADJ,PSADJD,PSADJP,PSADJQ,PSADRG,PSADT,PSAFLD,PSAGDF,PSAICST
 K PSAIDF,PSAIECST,PSAINV,PSAINVDT,PSAIVAL,PSAKK,PSALN,PSALSLN,PSAN,PSAODF,PSAOECST,PSAORD,PSAOUT,PSAPFLD,PSAPG,PSAPRC,PSAPRT,PSAQFLD,PSAREA,PSARPDT,PSARPT,PSASLN,PSASS,Y,ZTDESC,ZTRTN,ZTSAVE
 Q
 ;
LINE ;Get line item data
 S PSARPDT=$E($$HTFM^XLFDT($H),1,12),PSADT=$P(PSARPDT,".")
 S PSARPDT=$E(PSADT,4,5)_"/"_$E(PSADT,6,7)_"/"_$E(PSADT,2,3)_"@"_$P(PSARPDT,".",2)
 S (PSADJQ,PSADJP,PSADJD,PSAPFLD,PSAQFLD,PSAREA)="",(PSADRG,PSAACST,PSAICST)=0
 S PSADJ=+$O(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,"B","D",0))
 I $G(PSADJ) D
 .S PSAN=$G(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,PSADJ,0))
 .S PSADJD=$S($P(PSAN,"^",6)'="":$P(PSAN,"^",6),1:$P(PSAN,"^",2)),PSADRG=PSADJD
 .Q:$G(PSADJD)&($L(PSADJD)=+$L(PSADJD))
 E  S PSADRG=$P(PSADATA,"^",2)
 S PSAICST=$P(PSADATA,"^",3)*$P(PSADATA,"^",5),PSAIECST=PSAIECST+PSAICST
 S PSADJP=0,PSADJ=+$O(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,"B","P",0))
 I $G(PSADJ) D
 .S PSAN=$G(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,PSADJ,0)),PSAPRC=$S($P(PSAN,"^",6)'="":$P(PSAN,"^",6),1:+$P(PSAN,"^",2)),PSADJP=PSAPRC
 .S PSAPFLD="P"
 I '$G(PSADJ) S PSAPRC=$P(PSADATA,"^",5)
 S PSADJQ="",PSADJ=+$O(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,"B","Q",0))
 I $G(PSADJ) D
 .S PSAN=$G(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,PSADJ,0))
 .S PSADJQ=$S($P(PSAN,"^",6)'="":+$P(PSAN,"^",6),1:+$P(PSAN,"^",2))
 .S PSAREA=$S($P(PSAN,"^",7)'="":$P(PSAN,"^",7),1:$P(PSAN,"^",3)),PSAQFLD="Q"
 I $G(PSADJQ) S PSAACST=PSADJQ*PSAPRC,PSAAECST=PSAAECST+PSAACST
 I '$G(PSADJQ) S PSAACST=$P(PSADATA,"^",3)*PSAPRC,PSAAECST=PSAAECST+PSAACST
 I PSAICST'=PSAACST D
 .S PSALN=$P(PSADATA,"^")
 .S PSADRG=$S(+PSADRG&($P($G(^PSDRUG(PSADRG,0)),"^")'=""):$P(^PSDRUG(PSADRG,0),"^"),'PSADRG:PSADRG,1:"UNKNOWN DRUG")
 .I PSAPFLD="P" S PSA(PSAORD,PSAINV,PSALN,PSAPFLD)=PSADRG_"^^"_$J($P(PSADATA,"^",5),$L($P(PSADATA,"^",5)),2)_"^"_$J(PSADJP,$L(PSADJP),2)
 .I PSAQFLD="Q" S PSA(PSAORD,PSAINV,PSALN,PSAQFLD)=PSADRG_"^"_$S(PSAREA'="":PSAREA,1:"UNK")_"^"_$P(PSADATA,"^",3)_"^"_PSADJQ
 Q
 ;
GETLINE ;Gets invoice cost from line items
 S PSA2=0 F  S PSA2=$O(^PSD(58.811,PSA,1,PSA1,1,PSA2)) Q:'PSA2  D
 .Q:'$D(^PSD(58.811,PSA,1,PSA1,1,PSA2,0))
 .S PSADATA=^PSD(58.811,PSA,1,PSA1,1,PSA2,0),PSAIECST=PSAIECST+($P(PSADATA,"^",3)*$P(PSADATA,"^",5))
 .S PSADJP=0,PSADJ=+$O(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,"B","P",0))
 .I +PSADJ S PSAN=$G(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,PSADJ,0)),PSAPRC=$S($P(PSAN,"^",6)'="":$P(PSAN,"^",6),1:+$P(PSAN,"^",2)),PSADJP=PSAPRC
 .S:'+PSADJ PSAPRC=$P(PSADATA,"^",5)
 .;
 .S PSADJQ="",PSADJ=+$O(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,"B","Q",0))
 .S:+PSADJ PSAN=$G(^PSD(58.811,PSA,1,PSA1,1,PSA2,1,PSADJ,0)),PSADJQ=$S($P(PSAN,"^",6)'="":+$P(PSAN,"^",6),1:+$P(PSAN,"^",2))
 .S:$G(PSADJQ)'="" PSAAECST=PSAAECST+(PSADJQ*PSAPRC)
 .S:$G(PSADJQ)="" PSAAECST=PSAAECST+($P(PSADATA,"^",3)*PSAPRC)
 Q
 ;
CREDITS ;Adds existing credits to adjusted extended cost.
 S PSAC=0 F  S PSAC=$O(^PSD(58.811,PSA,1,PSA1,2,PSAC)) Q:'PSAC  D
 .Q:'$D(^PSD(58.811,PSA,1,PSA1,2,PSAC,0))
 .S PSACRED=PSACRED+$P(^PSD(58.811,PSA,1,PSA1,2,PSAC,0),"^",3)
 I PSAAECST'=PSAIECST D
 .S PSADF=PSAIECST-(PSAAECST+PSACRED)
 .S PSA(PSAORD,PSAINV)=$J(PSAIECST,$L(PSAIECST),2)_"^"_$J(PSAAECST,$L($P(PSAAECST,".")),2)_"^"_$J(PSACRED,$L(PSACRED),2)_"^"_$J(PSADF,$L(PSADF),2)_"^"_+$P($G(^PSD(58.811,PSA,1,PSA1,0)),"^",2)
 Q
 ;
PRINT ;Displays the invoices with outstanding credits
 D:PSARPT="S" HDRSUM D:PSARPT="D" HDRDET
 S PSAORD="" F  S PSAORD=$O(PSA(PSAORD)) Q:PSAORD=""!(PSAOUT)  D
 .S PSAODF=$P(PSA(PSAORD),"^",2)
 .I $Y+4>IOSL D:PSARPT="S" HDRSUM D:PSARPT="D" HDRDET Q:PSAOUT
 .W:PSARPT="S" ! W:PSARPT="D" !,PSALSLN W !,"ORDER#: "_PSAORD_" ($"_$P(PSA(PSAORD),"^")_")"
 .S PSAINV="" F  S PSAINV=$O(PSA(PSAORD,PSAINV)) Q:PSAINV=""  D
 ..S PSAIECST=$P(PSA(PSAORD,PSAINV),"^"),PSAAECST=$P(PSA(PSAORD,PSAINV),"^",2),PSACRED=$P(PSA(PSAORD,PSAINV),"^",3),PSAIDF=$P(PSA(PSAORD,PSAINV),"^",4)
 ..S PSAINVDT=$P(PSA(PSAORD,PSAINV),"^",5),PSAINVDT=$E(PSAINVDT,4,5)_"/"_$E(PSAINVDT,6,7)_"/"_$E(PSAINVDT,2,3)
 ..S PSAPRT=0,PSALN="" F  S PSALN=$O(PSA(PSAORD,PSAINV,PSALN)) Q:PSALN=""  D
 ...S PSAFLD="" F  S PSAFLD=$O(PSA(PSAORD,PSAINV,PSALN,PSAFLD)) Q:PSAFLD=""  D
 ....S PSADATA=PSA(PSAORD,PSAINV,PSALN,PSAFLD),PSADRG=$P(PSADATA,"^"),PSAREA=$P(PSADATA,"^",2),PSAIVAL=$P(PSADATA,"^",3),PSAAVAL=$P(PSADATA,"^",4),PSAPRT=PSAPRT+1
 ....I PSARPT="D",$Y+5>IOSL D HDRDET Q:PSAOUT
 ....I PSARPT="D" D:PSAPRT=1 PRTDLINE D:PSAPRT>1 PRTDLIN1
 ..I PSARPT="S",$Y+5>IOSL D HDRSUM Q:PSAOUT
 ..D:PSARPT="S" PRTSLINE
 .I $Y+4>IOSL D:PSARPT="S" HDRSUM D:PSARPT="D" HDRDET Q:PSAOUT
 .I PSAODF'=PSADF W !,"ORDER TOTAL" W:PSARPT="D" ?65 W:PSARPT="S" ?69 W $J(PSAODF,9,2)
 I $Y+4>IOSL D:PSARPT="S" HDRSUM D:PSARPT="D" HDRDET Q:PSAOUT
 W ! W:PSARPT="S" PSASLN W:PSARPT="D" PSALSLN
 W !,"GRAND TOTAL" W:PSARPT="D" ?65 W:PSARPT="S" ?69 W $J(PSAGDF,9,2),!
 I $E(IOST,1,2)="C-" D END^PSAPROC
 E  W @IOF
 Q
 ;
HDRDET ;Header for detail report
 I $E(IOST,1,2)="C-" W:'PSAPG @IOF D:+PSAPG END^PSAPROC Q:PSAOUT
 I $E(IOST)'="C",+PSAPG W @IOF
 S PSAPG=PSAPG+1
 W ! W:$E(IOST)'="C" "RUN DATE: "_PSARPDT
 W ?46,"DRUG ACCOUNTABILITY/INVENTORY INTERFACE"
 W !?53,"OUTSTANDING CREDITS REPORT",!?124,"PAGE "_PSAPG
 W !!?36,"INVOICE",?46,"ADJUSTED",?58,"RECEIVED",?68,"OUTST.",?84,"DRUG &"
 W !,"INVOICE#",?28,"DATE",?39,"COST",?50,"COST",?59,"CREDITS",?68,"CREDIT",?77,"LINE#",?84,"ADJUSTMENT REASON",?117,"INVOICE",?129,"ADJ",!
 W:PSAPG'=1 PSALSLN
 Q
 ;
PRTDLINE ;Prints a line of data on the detailed report
 W !,PSAINV,?26,PSAINVDT,?30,$J(PSAIECST,9,2),?45,$J(PSAAECST,9,2),?57,$J(PSACRED,9,2),?67,$J(PSAIDF,7,2),?74,$J(PSALN,8,0),?84,$E(PSADRG,1,33),?117,$J(PSAIVAL,7),?125,$J(PSAAVAL,7)
 W !?84,$S(PSAFLD="P":"ORDER UNIT PRICE CHANGED ",PSAFLD="Q":"QTY: "_PSAREA,1:"")
 Q
 ;
PRTDLIN1 ;Prints a line of data on the detailed report
 W !?74,$J(PSALN,8,0),?84,PSADRG,?117,$J(PSAIVAL,7),?125,$J(PSAAVAL,7)
 W !?84,$S(PSAFLD="P":"ORDER UNIT PRICE CHANGED ",PSAFLD="Q":"QTY: "_PSAREA,1:"")
 Q
 ;
HDRSUM ;Header for summary report
 I $E(IOST,1,2)="C-" W:'PSAPG @IOF D:+PSAPG END^PSAPROC Q:PSAOUT
 I $E(IOST)'="C",+PSAPG W @IOF
 S PSAPG=PSAPG+1
 W !?20,"DRUG ACCOUNTABILITY/INVENTORY INTERFACE"
 W !?27,"OUTSTANDING CREDITS REPORT",!?72,"PAGE "_PSAPG
 W ! W:$E(IOST)'="C" "RUN DATE: "_PSARPDT
 W !?36,"INVOICE",?46,"ADJUSTED",?58,"RECEIVED",?72,"OUTST."
 W !,"INVOICE#",?28,"DATE",?39,"COST",?50,"COST",?59,"CREDITS",?72,"CREDIT",!,PSASLN
 Q
 ;
PRTSLINE ;Prints a line of data on the summary report
 W !,PSAINV,?26,PSAINVDT,?30,$J(PSAIECST,9,2),?45,$J(PSAAECST,9,2),?57,$J(PSACRED,9,2),?71,$J(PSAIDF,7,2)
 Q
 ;
RPT ;Extended help for "Print a detailed or summary report"
 W !?5,"Select DETAILED to print the order number, invoice number, invoice date,",!?5,"total invoice cost, adjusted cost, received credits, and Derence."
 W !!?5,"Select SUMMARY to print all of the data on the detailed report plus the",!?5,"line item data that created the need for a credit. The line item data is"
 W !?5,"the line item number, drug name, quantity invoiced, quantity received,",!?5,"reason for credit."
 Q