import UnityEngine

class DebugScreen(MonoBehaviour):

	builder = System.Text.StringBuilder()

	uiText as UI.Text
	newlineAppended = false

	static instance as DebugScreen

	def Awake():
		uiText = GetComponent[of UI.Text]()
		instance = self

	def _log(str as string):
		if newlineAppended:
			builder.Append("\n")
			newlineAppended = false
		builder.Append(str)

	static def log(str as string):
		if instance:
			instance._log(str)

	def _logRow(str as string):
		log(str)
		newlineAppended = true

	static def logRow(str as string):
		if instance:
			instance._logRow(str)

	def LateUpdate():
		uiText.text = builder.ToString()
		# builder.Clear()
		builder = System.Text.StringBuilder()
