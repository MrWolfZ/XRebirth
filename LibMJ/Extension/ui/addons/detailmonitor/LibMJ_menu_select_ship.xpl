LJ @D:\Users\Joe\Documents\Visual Studio 2013\Projects\XRebirth\libmj\Extension\ui\addons\detailmonitor\sources\LibMJ_menu_select_ship.luaÉ   $44      T4   7     T4     7  % +  7+  7)  +  7+  7> T 4      T3  2  : 5   4 	 7 
 4  7+ > G   ÀÀinsert
tableregisterFuncs  rowProvidertitleProvideronMenuClosedonMenuInitLibMJ_ShipSelectionRegisterMenu
LibMJ							





Functions init  þ  ZÒ T4 (  ' >:  : 2  2  2  2  4 	 >T/4  % >  T4 7  >T#4  % >  T4 7  >T4  %	 >  T4 7  >T4  %
 >  T4 7  >ANÏ 	 		 		 	: 2 3	 :	;	3	 :	;	3	 :	;	3	 :	;	: 2  : G  selectedShips 
labelXL 
labelL 
labelM
ships 
labelScategoriesnrOfShipsship_sship_mship_linsert
tableship_xlIsComponentClassipairschooseMultipleReadText
titleº						





state  [title  [ships  [chooseMultiple  [smallShips 
QmediumShips PlargeShips OextraLargeShips N2 2 2_ /ship  / °   )-7  )  : )  :  )  : )  : )  : )  : 2 ;H 	argschooseMultiple
titlenrOfShipscategoriesselectedShips		state  selectedShips  y   ;4  7 > T7 4 7 > =   T7 H 	argsunpackfunction
title	typestate   K   H4   7  >G  ToggleRow
LibMJrowIdx  colIdx   Z   m 4    >4   > T) T) H tostring            s1  s2   ã (Ok
4  7+  7+ >4  7+ 74 7+ 7+ 1 > =+  7  T+  7 +  7	 T4  7
  >T4  7>G   ÀÀÀCloseMenuRemoveRownrOfShipschooseMultiple indexOf
LibMJ
shipsremoveselectedShipsinsert
table
state ship category rowIdx  )colIdx  ) Û' *×?G4  7 >TÃ74 	 7
 
 
>  T	7  2	  
 '  
 T
  T
%
 T%
 1 4	 7
	 4  7
  '  '    T) T) > =7%  % $4	 7
	 4  7 )  ' > =3 : 4	 7
 4  7	  4 7)  > =7   T4  7 ) >  Tn4   >Th2 4  7> < 4  % >4	 7
 4  7 > =4  % % % % % % % >	4 7 %! 4" ' é'! >  >  T'   T4 7 %#   4!" '"é'# >!" > 4 7 %$   4!" '"é'#>!" # $ > 4	 7
 4  !  7  " >  =4" ( ' è>1% 4 	 7 
 ! 4" #" 7""$ % >" = 3 & :' 4!	 7!
!" 4# $# 7##% &  ># =!0 AN0 AN;) : 4 7(3) ;) '     0  F    È PstandardButtonWidth	Ship   %s, %s: %s / %s / %s%s, %s: %.0f%%ReadText%s: %.0f%%formatstring	zonesectorclustershieldpercentshieldmaxhullpercenthullmax	nameGetComponentDataExpandRow!defaultHeaderBackgroundColorHelperRowCategory  	Cell) (
labelButtonCellinsert
table +-initializedIsExpanded
LibMJ
shipscategoriesipairsÀº         """"""""""#########$$$$$%%%%%%%%%%%''''''''''''')))))))))++++68888888888::;;;;;;;;;;;=@@BBBCCDEFFFFFstate  ØrowCollection  ØÆ Æ Æ_ Âcategory  Âships ÁisExpanded 
·cells ¶categoryExpandButtonLabel 	­categoryExpandScript ¬categoryLabel rowData nrOfChildRows k k k_ gship  gcells ashipName ]maxHull JhullPrc  JmaxShield  JshieldPrc  Jcluster  Jsector  Jzone  JshipStatus 	AselectShipButtonLabel *selectShipButtonScript rowData 
butWidth 	colWidths isColumnWidthsInPercent fixedRows  °  	 . 2   2  2  1  1 : 1 : 1 : 1 :  >0  G   rowProvider titleProvider onMenuClosed onMenuInit ++99==Functions Buttons  init   