import UnityEngine

class Loop (MonoBehaviour): 

	public skipIntro = false

	_currentMode = GameMode.Intro
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

	def Awake():
		doSkipIntro()

	def doSkipIntro():
		return unless skipIntro
		Camera.main.GetComponent[of RewindCamAnimation]().enabled = false
		GameObject.Find('/UI/Logo').SetActive(false)
		GameObject.Find('/UI/Start').SetActive(false)
		onIntroDone()

	def onIntroDone():
		currentMode = GameMode.Inhale

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
		pass

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
