#cs
This file is part of ClashGameBot.

ClashGameBot is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ClashGameBot is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ClashGameBot.  If not, see <http://www.gnu.org/licenses/>.
#ce
;Returns home when in battle, will take screenshot and check for gold/elixir change unless specified not to.

Func ReturnHome($TakeSS = 1, $GoldChangeCheck = True) ;Return main screen
		If $GoldChangeCheck = True Then
			;If $checkKPower Or $checkQPower Then
			;	If _Sleep(35000 - $delayActivateKQ) Then Return
			;Else
			;	If _Sleep(35000) Then Return
			;EndIf
			While GoldElixirChange()
				If _Sleep(1000) Then Return
			WEnd
		EndIf

		$checkKPower = False
		$checkQPower = False
		SetLog("Returning Home", $COLOR_BLUE)
		If $RunState = False Then Return
		Click(62, 519) ;Click Surrender
		If _Sleep(500) Then Return
		Click(512, 394) ;Click Confirm
		If _Sleep(500) Then Return

		If $TakeSS = 1 Then
			If _Sleep(2500) Then Return
			SetLog("Taking snapshot of your loot", $COLOR_GREEN)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "-" & @MIN
			_CaptureRegion()
			$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $Date & "_" & $Time & "_" & StringFormat("%3s", $SearchCount) & ".jpg")
			;attackReport()
		EndIf

		;If _Sleep(2000) Then Return
		Click(428, 544) ;Click Return Home Button

		Local $counter = 0
		While 1
			If _Sleep(2000) Then Return
			_CaptureRegion()
			If _ColorCheck(_GetPixelColor(284, 28), Hex(0x41B1CD, 6), 20) Then
				_GUICtrlEdit_SetText($txtLog, "")
				Return
			EndIf

			$counter += 1

			If $counter >= 50 Then
				SetLog("Cannot return home.", $COLOR_RED)
				checkMainScreen()
				Return
			EndIf
		WEnd
EndFunc   ;==>ReturnHome