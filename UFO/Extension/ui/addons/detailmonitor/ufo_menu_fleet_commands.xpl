LJ �@D:\Users\Joe\Documents\Visual Studio 2013\Projects\XRebirth\ufo\Extension\ui\addons\detailmonitor\sources\ufo_menu_fleet_commands.lua�   %54      T�4   7     T�4     7  % +  7+  7+  7+  7+  7> T �4      T�3  2  :	 5   4 
 7  4  7	+ > G   ��insert
tableregisterFuncs  rowProvidertitleProvideronReturnArgsReceivedonMenuClosedonMenuInitUFOChooseFleetCommandRegisterMenu
LibMJ							





Functions init  �  +4 (  ' >% 7% $:  : : G  playerShips
fleet'	name 'ReadText
title��state  fleet  playerShips   7   7    T�2  H returnArgsstate   �  
 6g7   T�8  T� '   T�2 4 77;8;: 4  7>) H )  :  7   T�8  T� '   T�2 4 77	;8;: 4  7>) H )  :  ) H moveToZoneMoveToZoneCloseMenu
LibMJescortShipcommandUFOreturnArgsEscortShipsubMenu

state  7closeAll  7returnArgs  7ships zones  #   87  H 
titlestate   G   F +   7   + > G     �selectEscortShip     Buttons state  H   R +   7   + > G     �selectZoneForMove     Buttons state  ���<' 4   72 4   7*	 '
 > <  )  4  77) >4 7  >2 4   7> <  4 77	7
1 + 7  > '    T�) T�) 4 7	 4
  
 7

  '  )   >
 =4 7	 4
  
 7

>
 =4 7	 4
  
 7

 )  4  77) >
 =4 7	 
 >2 4	  
	 7		>	 <	   4 777
1	 4
 7

 4   7 	 ' ) )   > =
4
 7

 4   7> =
4
 7

 4   7 )  4  77) > =
3
 0  �H
 � �  �  moveToZoneButtonCellgetShipsForEscort 
labelescortShipcommandUFOinsert
tabletransparentcolors	CellRow
LibMJ����				
Buttons Functions state  �rowCollection  �buttonFontSize �emptyRow wcells lescortShipButtonLabel hescortShipButtonScript gescortShipButtonSelectable \moveToZoneButtonLabel 4(moveToZoneButtonScript 'colWidths % �  $[\2 4  > <  7 7  7  T�4 7 >T�4 	 %
 >7	4
  >
6	
	 	 T	�  T	�4		 7	
	
  >	AN�H insert
tabletostringshipsByIdship_xsIsComponentClassipairs
shipsplayerShips
fleetGetPlayerPrimaryShipID����				








state  %ships  fleet 	  _ ship  isDrone  � K�o% :  4 (  ' >+  7  >4 7 7% >  T�4 7 7% >2  4 (  ')#>4	  >T	!�4 
 % >  T�4 
 % >4
 7 3 :
  T� T�) T�) : T� T�%  % $:>A	N	�4  7% )	  
  >G   �LibMJ_ShipSelectionOpenMenu
LibMJadditionalLabel)(selectable	ship  insert
tableipairsship_mship_scommander
fleetIsComponentClassgetShipsForEscortReadTextEscortShipsubMenu��				





Functions state  Ltitle Eships AcommanderIsFighter 5shipDescriptors 4notSupportedYetLabel 0$ $ $_ !ship  !shipIsFighter 
 �  U�% :  4 (  ' >4 7 7% % >2 ;;4  7	%
 )  	 )
  >G  LibMJ_ZoneSelectionOpenMenu
LibMJsectoridclusteridcommander
fleetGetComponentDataReadTextMoveToZonesubMenu��state  title fleetCluster fleetSector  preExtended 
 �   5 �2   2  1  1 : 1 : 1 : 1 : 1
 :	 1 : 1 :1 : >0  �G   selectZoneForMove selectEscortShip getShipsForEscort rowProvider titleProvider onReturnArgsReceived onMenuClosed onMenuInit 66::ZZmm��������Functions Buttons  init   