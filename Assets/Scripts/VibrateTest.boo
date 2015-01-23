import UnityEngine

class VibrateTest (MonoBehaviour): 

	def Start ():
		Vibration.Vibrate()

	def OnGUI():
		myStyle = GUIStyle(GUI.skin.button)
		# myFont = new Font()
		# fontface
		# myStyle.font = myFont
		myStyle.fontSize = 48

		if GUI.Button(Rect(20, 40, 300, 100), "Vibrate 1000", myStyle):
			Vibration.Vibrate(1000)
		if GUI.Button(Rect(20, 160, 300, 100), "Pattern 1", myStyle):
			pattern1 = array[of long]((2))
			pattern1[0] = 200 # off
			pattern1[1] = 20 # on
			Vibration.Vibrate(pattern1, 0)
		if GUI.Button(Rect(20, 280, 300, 100), "Pattern 2", myStyle):
			pattern2 = array[of long]((2))
			pattern2[0] = 200 # off
			pattern2[1] = 10 # on
			Vibration.Vibrate(pattern2, 0)
		if GUI.Button(Rect(20, 280, 300, 100), "Pattern 3", myStyle):
			pattern3 = array[of long]((2))
			pattern3[0] = 200 # off
			pattern3[1] = 10 # on
			Vibration.Vibrate(pattern3, 0)
		if GUI.Button(Rect(20, 280, 300, 100), "Pattern 4", myStyle):
			pattern4 = array[of long]((2))
			pattern4[0] = 200 # off
			pattern4[1] = 10 # on
			Vibration.Vibrate(pattern4, 0)
		if GUI.Button(Rect(20, 280, 300, 100), "Pattern 5", myStyle):
			pattern5 = array[of long]((2))
			pattern5[0] = 200 # off
			pattern5[1] = 10 # on
			Vibration.Vibrate(pattern5, 0)
		if GUI.Button(Rect(20, 400, 300, 100), "Cancel", myStyle):
			Vibration.Cancel()
