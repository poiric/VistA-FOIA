YSCEN1 ;ALB/ASF-MH CENSUS ENTRY/EDIT; 4/16/92  09:52
 ;;5.01;MENTAL HEALTH;**52**;Dec 30, 1994
 ;
1 ; Called from MENU option YSCENUNITUP
 ;
 S DIC("A")="Select Mental Health Ward: ",DIC="^YSG(""CEN"",",DIC(0)="AEQLM",DLAYGO=618 D ^DIC K DIC I Y<1 G END
 S DA=+Y,DIE="^YSG(""CEN"",",DR="[YSCEN UNIT DEF]"
 L +^YSG("CEN",DA):5 I '$T W !,"Record being updated" Q
 D ^DIE L -^YSG("CEN",DA) S YSTOUT=$D(DTOUT) I YSTOUT G END
 G 1
 ;
2 ; Called from MENU option YSCENSUBUP
 ;
 S DIC="^YSG(""SUB"",",DIC(0)="AEQL",DLAYGO=618 D ^DIC I Y<1 G END
 S DA=+Y,DIE=DIC,DR="0:99"
 L +^YSG("SUB",DA):5 I '$T W !,"Record being updated" Q
 D ^DIE L -^YSG("SUB",DA) S YSTOUT=$D(DTOUT) I YSTOUT G END
 G 2
3 ;
 K DIC,DLAYGO,DR,DIE S DIC("S")="I $P(^YSG(""INP"",+$G(Y),7),U)=W1",DIC="^YSG(""INP"",",DIC(0)="EQZM",YSFLG=0
 R !,"Select Patient: ",X:DTIME S YSTOUT='$T,YSUOUT=X["^" G:YSTOUT!YSUOUT END Q:X=""  I X?1"?".E W !?5,"Select a Patient within the previously selected Inpatient Ward",! S DZ="??",D="CP" D DQ^DICQ G 3
 K DIC("S") D 1^YSLRP I $G(YSTOUT) G END
 G:YSDFN<1 3 S (YDA,DA)=$O(^YSG("INP","CP",YSDFN,0)) I YDA,+^YSG("INP",YDA,7)'=W1 S YDA=-1
 I YDA<1 W !,$P(^DPT(YSDFN,0),U)," not currently a patient on this ward",$C(7) G 3
4 ;
 S DIE="^YSG(""INP"",",DR="2;3"
 L +^YSG("INP",DA):5 I '$T W !,"Record being updated" Q
 D ^DIE L -^YSG("INP",DA) S YSTOUT=$D(DTOUT) I YSTOUT G END
 G:$D(Y) 3:'YSFLG,Q S W5=$P(^YSG("INP",YDA,0),U,4)
 S DIC=200,DIC(0)="AEQ",DIC("A")=$S(W5<1:"Staff",$P(^YSG("SUB",W5,0),U,10)]"":$P(^(0),U,10),1:"Staff")_": "
 I $P(^YSG("INP",DA,0),U,5)?1N.N S DIC("A")=DIC("A")_$P(^VA(200,$P(^YSG("INP",DA,0),U,5),0),U)_" // "
 D ^DIC K DIC S YSTOUT=$D(DTOUT) I YSTOUT G END
 G:X="^" 3:'YSFLG,Q I +Y?1N.N,Y>1 S DR="4////"_+Y
 L +^YSG("INP",DA):5 I '$T W !,"Record being updated" Q
 D ^DIE L -^YSG("INP",DA)
 S DR="5:6;7;8;9;12:17"
 L +^YSG("INP",DA):5 I '$T W !,"Record being updated" Q
 D ^DIE L -^YSG("INP",DA) S YSTOUT=$D(DTOUT) I YSTOUT G END
 G:$D(Y) 3:'YSFLG,Q
 I $D(^YSG("INP",DA,5,1)) D COM^YSCEN22 W !
COMM ;
 R !,"Do you wish to enter an Inpatient comment? N// ",X:DTIME S YSTOUT='$T,YSUOUT=X["^"
 Q:YSUOUT  S YSR1="X",YSR2="N",YSR3="YN" D ^YSCEN14 G COMM:X="?" G DXE:X="N" I X=-1 G Q:YSFLG,3:'YSFLG
 ;
CM ; Called from routine YSCEN51
 ;
 S DIC="^YSG(""INP"",YDA,5,",DIC(0)="L",DLAYGO=618,X="""NOW""",DA(1)=YDA,$P(^YSG("INP",YDA,5,0),U,2)="618.418D" D ^DIC S DA=+Y,DIE="^YSG(""INP"",YDA,5,",DR="1///^S X=""`""_DUZ;2"
 L +^YSG("INP",YDA):5 I '$T W !,"Record being updated" Q
 D ^DIE L -^YSG("INP",YDA)
 S YSTOUT=$D(DTOUT) I YSTOUT G END
DXE ;
 R !,"Do you wish to enter diagnoses? N// ",X:DTIME S YSTOUT='$T,YSUOUT=X["^" Q:YSTOUT
 S YSR1="X",YSR2="N",YSR3="YN" D ^YSCEN14 G DXE:X="?",PLE:X="N" G:X=-1&('YSFLG) 3 Q:X=-1&(YSFLG)  D DXE1 G PLE
DXE1 ;
 S YSDFN1=YSDFN
 N C1,C2,DA,I,J,P1,W1,W2,YSDFN
 K YSQT S YSDFN=YSDFN1,YSDUZ=$P(^VA(200,DUZ,0),U) D ENPT^YSUTL
 W @IOF,!?7,"Diagnosis Entry",?$X+5,YSNM,?$X+5,YSSSN,! D OLD^YSDX3 I YSTOUT G END
 D ^YSDX3A I YSTOUT G END
 D AXIS4^YSDX3B I YSTOUT G END
 D AXIS5^YSDX3B
 Q
PLE ;
 R !,"Do you wish to enter Problem List? N// ",X:DTIME S YSTOUT='$T,YSUOUT=X["^" Q:YSTOUT
 S YSR1="X",YSR2="N",YSR3="YN" D ^YSCEN14 G PLE:X="?" G:X=-1&('YSFLG) 3 Q:X=-1&(YSFLG)  D:X'="N" PLE1 G 3
PLE1 ;
 S YSDFN1=YSDFN N DA,I,P1,S2,YSDFN,YSNM S YSDFN=YSDFN1 D ENPT^YSUTL W @IOF,!?7,"Problem List Entry",?$X+5,YSNM,?$X+5,YSSSN,! D H^YSPROB,ENA1^YSPROB:$D(^YS(615,YSDFN,"PL")),F1^YSPROB:$D(YSDFN) Q
 ;
ED ; Called from MENU option YSCENED
 ;
 K DIC D UN^YSCEN2 G:Y<1 END S (P1,Q3)=0,YSFLG=0 D FS0^YSCEN,UNLST^YSCEN13 G:$D(YSTOUT) END D 3 G END
 ;
EDG ; Called from MENU option YSCENGED
 ;
 K YSOPT1,YSOPT2,YSQT S IOP=0,YSFLG=1 D A1^YSCEN3 Q:Y<1  S P1=0,YSOPT2="GED^YSCEN1" D:T6'="A" L2^YSCEN2 D:T6="A" L1^YSCEN2
 G END
GED ;
 S:'$D(Q3) Q3=0 S YSNM=""
 F  S YSNM=$O(^UTILITY($J,YSNM)) Q:YSNM=""!(Q3)  S YSDFN=$O(^UTILITY($J,YSNM,0)),YSFLG=1,(DA,YDA)=$O(^YSG("INP","CP",YSDFN,0)) I YDA D ENPT^YSUTL W @IOF,!?7,YSNM,?$X+5,YSSSN,?$X+5,"TEAM: ",$P(^YSG("SUB",T6,0),U),! D 4,WAIT Q:Q3
Q ;
 Q
NW ;
 D ENDTM^YSUTL S Y=YSDTM D ENDD^YSUTL Q
 ;
END ; Called from routine YSCEN13
 ;
 K C,C1,C2,D0,DA,DIYS,DIC,DIE,DR,DQ,E2,E3,I,P1,J,Q3,R,W2,W4,W5,W1,X,Y,YSDFN,YSDFN1,YSQT,YSAGE,YSBID,YSDOB,YSHDR,YSNM,YSOPT2,YSSEX,YSSSN,VA,VADM,X1,X1,YSD,YSNM,YDA,YSHR Q
WAIT ;  Called from routine YSCEN, YSCEN2, YSCEN21, YSCEN22, YSCEN23, YSCEN24
 ;  YSCEN26, YSCEN3, YSCEN32, YSCEN33, YSCEN34, YSCEN35, YSCEN39
 ;  YSCEN4, YSCEN5, YSCEN52, YSCEN53, YSCEN55, YSCEN6, YSCEN61, YSCEN7
 ;  YSCEN8, YSCEN81
 I $D(Q3) Q:Q3
 ;I $D(YSO) Q:YSO=10
 I $D(YSOPT1),YSOPT1="PROB^YSCEN3",$D(YSLFT) S Q3=+$G(YSLFT) Q
 I IOST?1"C-".E F ZZ=1:1:(IOSL-$Y-4) W !
 Q:IOST["P-"!(IOST["PK-")
 S DIR(0)="E" D ^DIR K DIR S Q3=$D(DIRUT) Q
 ;
COPIES ; Called from routine YSCEN23, YSCEN35
 ;
 S YSCOP=1 I $D(IOST),IOST'?1"C".E R !,"How many copies? (1-4) 1// ",YSCOP:DTIME S YSTOUT='$T,YSUOUT=YSCOP["^" Q:YSTOUT
 S YSR1="YSCOP",YSR2=1,YSR3=4 D ^YSCEN14 G COPIES:YSCOP="?" Q
 Q