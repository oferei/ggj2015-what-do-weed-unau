import UnityEngine

class DebugScreen(MonoBehaviour): 

	builder = System.Text.StringBuilder()

	uiText as UI.Text
	newlineAppended = false

	def Awake():
		uiText = GetComponent[of UI.Text]()

	def log(str as string):
		if newlineAppended:
			builder.Append("\n")
			newlineAppended = false
		builder.Append(str)

	def logRow(str as string):
		log(str)
		newlineAppended = true

	def LateUpdate():
		uiText.text = builder.ToString()
		# builder.Clear()
		builder = System.Text.StringBuilder()
