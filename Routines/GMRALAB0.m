GMRALAB0 ;HIRMFO/WAA-THIS PROGRAM WILL SELECT ALL LAB TEST FOR A PATIENT ;1/9/96  09:47
 ;;4.0;Adverse Reaction Tracking;;Mar 29, 1996
EN1 ;THIS PROGRAM IS TO FIND AND PRINT ALL LAB TEST FOR A PATIENT
 G:GMRAOUT EXIT
 W @IOF N DIE,DA,GMRAXXX,GMRAX,GMRAGHC
 S GMRALRCV=$S($T(GMTSLRCE^GMTSLRCE)']"":0,1:+$$VERSION^XPDUTL("GMTS"))
 S GMRALRCG=$S(+GMRALRCV>2:"^TMP(",1:"^UTILITY(")
 K @(GMRALRCG_"""LRC"",$J)"),^TMP($J,"GMRALAB")
 S GMRADT=$P(^GMR(120.85,GMRAPA1,0),U)
 D ^GMRADSP7 Q:'GMRAPA
SELECT W ! D LST
 ;SELECT ACTION
 S GMRAOUT=0
 K DIR S DIR(0)="SMOBA^A:ADD;D:DELETE;E:EDIT",DIR("A")="Select Action (A/D/E): "
 S DIR("?",1)="ENTER A TO ADD NEW LAB DATA, D TO DELETE LAB DATA OR "
 S DIR("?")="E TO EDIT LAB DATA ON FILE FOR THIS PATIENT"
 D ^DIR K DIR I "^^"[Y S GMRAOUT=$L(Y) G EXIT
 S GMRASEL=Y K DIR,GMRADFL
 I GMRASEL="A" S GMRALOOK=0 W ! D ADD^GMRALAB1 K GMRALOOK G:GMRAOUT&('$D(GMRADFL)) EXIT G SELECT
 I GMRASEL="D" W ! D DEL^GMRALAB1 G:GMRAOUT EXIT G SELECT
 I GMRASEL="E" W ! D EDIT^GMRALAB1 G:GMRAOUT EXIT G SELECT
 G SELECT
DISP ;DISPLAY ALL THE LABTEST FOR THIS PATIENT
 K @(GMRALRCG_"""LRC"",$J)"),^TMP($J,"GMRALAB") S GMRACT=1,GMRACH=1
 S DFN=+GMRAPA(0)
 D DT Q:GMRAOUT
 S GMRALOOK=1
 I $D(GMRABGDT),+GMRALRCV S SEX=$P(GMRASEX,U),GMTS1=9999999-GMRAENDT,GMTS2=9999999-GMRABGDT,MAX=9999999,LRDFN=$P($G(^DPT(DFN,"LR")),U) D:LRDFN XTRCT^GMTSLRCE
 K GMTS1,GMTS2,MAX,SEX,LRDFN
 S GMRACT=0,GMRAX=0 F  S GMRAX=$O(@(GMRALRCG_"""LRC"",$J,GMRAX)")) Q:GMRAX<1  D
 .S GMRAY=0 F  S GMRAY=$O(@(GMRALRCG_"""LRC"",$J,GMRAX,GMRAY)")) Q:GMRAY'>0  D
 ..S GMRACT=GMRACT+1,^TMP($J,"GMRALAB","L",GMRACT)=@(GMRALRCG_"""LRC"",$J,GMRAX,GMRAY)")
 ..Q
 .Q
DISP2 S Z=0 W @IOF,!,"LAB TEST:",!,?3,"Collection DT",?19,"Test Name",?39,"Specimen",?52,"Results",?68,"Hi/Low",!!
 I '$D(^TMP($J,"GMRALAB","L")) W ?5,$S('GMRALRCV:"THE LAB EXTRACT IS NOT PRESENT, COULD NOT GET LAB TEST DATA",1:"THERE IS NO LAB DATA FOR THIS PATIENT FOR THIS DATE RANGE.") K GMRABGDT,GMRAENDT Q
 F GMRACH=GMRACH:1 Q:'$D(^TMP($J,"GMRALAB","L",GMRACH))  D  Q:GMRAOUT
 .I $Y+3>IOSL D  Q:GMRAOUT
 ..S DIR(0)="E" D ^DIR I 'Y S GMRAOUT=1 S:$D(DIROUT) GMRAOUT=2
 ..K Y,DIR,DIRUT,DIROUT,DUOUT,DTOUT
 ..I GMRAOUT Q
 ..W @IOF,!,"LAB TEST:",!,?3,"Collection DT",?19,"Test Name",?39,"Specimen",?52,"Results",?68,"Hi/Low",!!
 ..Q
 .W $J(GMRACH,Z),?4,$P(^TMP($J,"GMRALAB","L",GMRACH),U)
 .W ?20,$E($P(^TMP($J,"GMRALAB","L",GMRACH),U,3),1,18)
 .W ?39,$E($P(^TMP($J,"GMRALAB","L",GMRACH),U,2),1,10)
 .I $P(^TMP($J,"GMRALAB","L",GMRACH),U,5)'="" W ?50,$P(^TMP($J,"GMRALAB","L",GMRACH),U,5)
 .W ?53,$E($P($P(^TMP($J,"GMRALAB","L",GMRACH),U,4),"|"),1,10)," ",$P(^TMP($J,"GMRALAB","L",GMRACH),U,6)
 .W ?68 I $P(^TMP($J,"GMRALAB","L",GMRACH),U,8)'="" W $P(^TMP($J,"GMRALAB","L",GMRACH),U,8),"/",$P(^TMP($J,"GMRALAB","L",GMRACH),U,7)
 .W !
 .Q
 K X,GMRACH,GMRACT,GMRAX,GMRAY,GMRAZ,X,Y
 Q
LST ;This entry point is to display patient lab test adverse reaction.
 I '$O(^GMR(120.85,GMRAPA1,4,0)) W !,"THIS PATIENT HAS NO LAB TEST ON FILE FOR THIS ADVERSE REACTION REPORT" K GMRABGDT,GMRAENDT Q
 W @IOF,!,"This patient has the following Test selected: "
 W !,"TEST/TX",?33,"RESULTS",?64,"DRAW DATE/TIME"
 S GMRAXX=1,GMRAX=0 F  S GMRAX=$O(^GMR(120.85,GMRAPA1,4,GMRAX)) Q:GMRAX<1  D  Q:GMRAOUT
 .I $Y+3>IOSL D  Q:GMRAOUT
 ..S DIR(0)="E" D ^DIR I 'Y S GMRAOUT=1 S:$D(DIROUT) GMRAOUT=2
 ..K Y,DIR,DIRUT,DIROUT,DUOUT,DTOUT
 ..I GMRAOUT Q
 ..W @IOF,!,"TEST/TX",?33,"RESULTS",?64,"DRAW DATE/TIME"
 ..Q
 .W !,GMRAXX_") ",?5,$E($P(^GMR(120.85,GMRAPA1,4,GMRAX,0),U),1,26)
 .W ?33,$E($P(^GMR(120.85,GMRAPA1,4,GMRAX,0),U,2),1,30)
 .W ?64 W:$P(^GMR(120.85,GMRAPA1,4,GMRAX,0),U,3)>1 $$LDATE^GMRALAB1($P(^GMR(120.85,GMRAPA1,4,GMRAX,0),U,3))
 .S GMRAXX=GMRAXX+1
 .Q
 K GMRAXX,GMRAX
 Q
DT ;SELECT LOOKUP DATE RANGE
 I GMRALOOK Q
 I '$D(GMRABGDT) S (GMRABGDT,GMRAENDT)=""
 W ! K GMRADFL
 S X1=$S(GMRABGDT'="":+GMRABGDT,1:GMRADT),X2=0 D C^%DTC S Y=X D D^DIQ S %DT("A")="View Tx/Test from: ",%DT("B")=Y,%DT="AETP" D ^%DT K %DT I X="^" S GMRAOUT=2,GMRADFL=1 G DTEX
 S GMRABGDT=+Y D D^DIQ S $P(GMRABGDT,U,2)=Y
 S X1=$S(GMRAENDT'="":+GMRAENDT,1:GMRADT),X2=0 D C^%DTC S Y=X D D^DIQ S %DT("A")="To: ",%DT("B")=Y,%DT="AETP",%DT(0)=+GMRABGDT D ^%DT K %DT I X="^" S GMRAOUT=2,GMRADFL=1 G DTEX
 S GMRAENDT=+Y S:'$P(GMRAENDT,".",2) GMRAENDT=GMRAENDT+.24 D D^DIQ S $P(GMRAENDT,U,2)=Y
DTEX K X2,X1,Y,X,%DT
 Q
EXIT ;EXIT THE PROGRAM
 K GMRADT,GMRABGDT,GMRAENDT,GMRASEL,DIR,X,Y,^TMP($J,"GMRALAB"),@(GMRALRCG_"""LRC"",$J)"),GMRALOOK,GMRADFL
 Q