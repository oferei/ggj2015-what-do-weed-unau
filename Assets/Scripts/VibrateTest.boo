import UnityEngine

class VibrateTest(MonoBehaviour):

	onText = "1"
	offText = "300"

	def Start ():
		Vibration.Vibrate()

	def OnGUI():
		labelStyle = GUIStyle(GUI.skin.label)
		labelStyle.fontSize = 48
		buttonStyle = GUIStyle(GUI.skin.button)
		buttonStyle.fontSize = 48
		textFieldStyle = GUIStyle(GUI.skin.textField)
		textFieldStyle.fontSize = 48
		
		GUI.Label(Rect(20, 40, 300, 60), "On (ms)", labelStyle)
		onText = GUI.TextField(Rect(20, 120, 300, 60), onText, textFieldStyle)
		GUI.Label(Rect(340, 40, 300, 60), "Off (ms)", labelStyle)
		offText = GUI.TextField(Rect(340, 120, 300, 60), offText, textFieldStyle)
		if GUI.Button(Rect(20, 200, 300, 100), "Start", buttonStyle):
			pattern3 = array[of long]((2))
			pattern3[0] = long.Parse(offText)
			pattern3[1] = long.Parse(onText)
			Vibration.Vibrate(pattern3, 0)
		if GUI.Button(Rect(340, 200, 300, 100), "Stop", buttonStyle):
			Vibration.Cancel()
