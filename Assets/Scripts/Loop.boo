import UnityEngine

class Loop (MonoBehaviour): 

	public initialMode = GameMode.Intro

	_currentMode = GameMode.Undefined
	currentMode:
		get:
			return _currentMode
		set:
			if _currentMode != value:
				lastMode = _currentMode
				_currentMode = value
				Debug.Log("Game mode: $(currentMode)")
				onModeChanged()

	lastMode = GameMode.Undefined

	def Start():
		currentMode = initialMode

	def onModeChanged():
		MessageMode(currentMode)

		if currentMode == GameMode.Intro:
			onModeIntro()
		elif currentMode == GameMode.Dialogue:
			onModeDialogue()
		elif currentMode == GameMode.Inhale:
			onModeInhale()
		elif currentMode == GameMode.Cough:
			onModeCough()
		elif currentMode == GameMode.Hold:
			onModeHold()
		elif currentMode == GameMode.Exhale:
			onModeExhale()
		else:
			Debug.LogError("Unknown mode: $(currentMode)")

	def onModeIntro():
		currentMode = GameMode.Inhale

	def onModeDialogue():
		pass

	def onModeInhale():
		pass

	def onModeCough():
		pass

	def onModeHold():
		pass

	def onModeExhale():
		pass

	def onCough():
		currentMode = GameMode.Cough

	def onDoneCoughing():
		currentMode = GameMode.Inhale
