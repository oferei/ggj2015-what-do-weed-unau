import UnityEngine

class Loop (MonoBehaviour): 

	public initialMode = GameMode.Intro

	_currentMode = GameMode.Undefined
	currentMode:
		get:
			return _currentMode
		set:
			if _currentMode != value:
				_currentMode = value
				Debug.Log("Game mode: $(currentMode)")
				onModeChanged()

	def Start():
		currentMode = initialMode

	def onModeChanged():
		MessageMode(currentMode)

		if currentMode == GameMode.Intro:
			currentMode = GameMode.Inhale

	def OnEnable():
		God.inst.hermes.listen(MessageYouTookTooMuchMan, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageYouTookTooMuchMan, self)

	def OnMsgYouTookTooMuchMan(msg as MessageYouTookTooMuchMan):
		Debug.Log("YouTookTooMuchMan")
