XTNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;2950425.092013
 ;;7.3;TOOLKIT;;Apr 25, 1995
 ;;7.3;2950425.092013
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 G CONT^XTNTEG0
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
XDRCNT ;;7651887
XDRDADD ;;8133407
XDRDADJ ;;4509269
XDRDCOMP ;;4431965
XDRDFPD ;;7816795
XDRDLIST ;;7786460
XDRDMAIN ;;5700890
XDRDOC ;;19083
XDRDOC1 ;;13351
XDRDOC2 ;;19767
XDRDPDTI ;;2075925
XDRDPRGE ;;3959904
XDRDQUE ;;9275556
XDRDSCOR ;;1855732
XDRDSTAT ;;2676366
XDRDUP ;;3547600
XDREMSG ;;4302480
XDRERR ;;127648
XDRHLP ;;2681700
XDRMADD ;;6382715
XDRMAIN ;;7563507
XDRMAINI ;;14611797
XDRMPACK ;;2927651
XDRMRG ;;14311248
XDRMRG1 ;;1874512
XDRMSG ;;1827956
XDRMVFY ;;1318075
XDRPREI ;;293004
XDRU1 ;;1782236
XINDEX ;;7227772
XINDX1 ;;6096231
XINDX10 ;;12585180
XINDX11 ;;7471101
XINDX2 ;;5054188
XINDX3 ;;3897455
XINDX4 ;;4711071
XINDX5 ;;6259999
XINDX51 ;;9529173
XINDX52 ;;2298647
XINDX53 ;;4122188
XINDX6 ;;10179476
XINDX7 ;;7575886
XINDX8 ;;6101428
XINDX9 ;;4045898
XTBASE ;;2331979
XTCMFILN ;;4125344
XTEDTVXD ;;1542362
XTFC0 ;;11055774
XTFC1 ;;14547133
XTFCE ;;5859522
XTFCE1 ;;6311273
XTFCR ;;5587602
XTFCR1 ;;3692308
XTINEND ;;5215462
XTINI001 ;;5950864
XTINI002 ;;4393549
XTINI003 ;;6019987
XTINI004 ;;4028880
XTINI005 ;;3990558
XTINI006 ;;9416677
XTINI007 ;;9086371
XTINI008 ;;8419298
XTINI009 ;;8019911
XTINI00A ;;9113926
XTINI00B ;;11110278
XTINI00C ;;11151493
XTINI00D ;;9306443
XTINI00E ;;8494510
XTINI00F ;;8489467
XTINI00G ;;7747693
XTINI00H ;;7094018
XTINI00I ;;7643278
XTINI00J ;;8405097
XTINI00K ;;7198108
XTINI00L ;;6651500
XTINI00M ;;8180768
XTINI00N ;;7132260
XTINI00O ;;2910462
XTINI00P ;;7694041
XTINI00Q ;;8160242
XTINI00R ;;9440499
XTINI00S ;;9016307
XTINI00T ;;9491800
XTINI00U ;;10283373
XTINI00V ;;8766708
XTINI00W ;;6509886
XTINI00X ;;8595714
XTINI00Y ;;7948819
XTINI00Z ;;1773424
XTINI010 ;;7071607
XTINI011 ;;5531060
XTINI012 ;;7968888
XTINI013 ;;11142565
XTINI014 ;;2687098
XTINI015 ;;8767076
XTINI016 ;;3859202
XTINI017 ;;7490625
XTINI018 ;;2613367
XTINI019 ;;4541347
XTINI01A ;;7350290
XTINI01B ;;3719011
XTINI01C ;;6289769
XTINI01D ;;1212716
XTINI01E ;;5998915
XTINI01F ;;5482770
XTINI01G ;;3469421
XTINI01H ;;1876516
XTINI01I ;;5948679
XTINI01J ;;5624949
XTINI01K ;;7118498
XTINI01L ;;5020375
XTINI01M ;;6515584
XTINI01N ;;7612374
XTINI01O ;;7804125
XTINI01P ;;7864176
XTINI01Q ;;7980433
XTINI01R ;;7872517
XTINI01S ;;7885668
XTINI01T ;;8156338
XTINI01U ;;5743708
XTINI01V ;;8379152
XTINI01W ;;7143097
XTINI01X ;;6494785
XTINI01Y ;;6468654
XTINI01Z ;;6344717
XTINI020 ;;6053332
XTINI021 ;;6154942
XTINI022 ;;6263758
XTINI023 ;;6988435
XTINI024 ;;7095170
XTINI025 ;;5225531
XTINI026 ;;6836611
XTINI027 ;;7165347
XTINI028 ;;7867999
XTINI029 ;;5902113
XTINI02A ;;7114778
XTINI02B ;;6562588
XTINI02C ;;5066519
XTINI02D ;;4746121
XTINI02E ;;3747162
XTINI02F ;;1763576
XTINIS ;;2134872
XTINIT ;;11072830
XTINIT1 ;;5762600
XTINIT2 ;;5232093
XTINIT3 ;;16090016
XTINIT4 ;;3357263
XTINIT5 ;;1525744
XTINITY ;;15382450
XTINOK ;;2394003
XTKERM1 ;;5596187
XTKERM2 ;;7359658
XTKERM3 ;;2782884
XTKERM4 ;;5378382
XTKERMIT ;;2016322
XTLATSET ;;6413686
XTLKDICL ;;2562328
