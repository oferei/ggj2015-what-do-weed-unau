import UnityEngine

class Loop (MonoBehaviour): 

	public skipIntro = false
	public logoObject as GameObject
	public StartObject as GameObject
	public delayAfterIntro as single = 2.0

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
		Camera.main.GetComponent[of RewindCamAnimation]().enabled = not skipIntro
		logoObject.SetActive(not skipIntro)
		StartObject.SetActive(not skipIntro)
		if skipIntro:
			onIntroDone()

	def onIntroDone():
		currentMode = GameMode.Dialogue

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
		currentMode = GameMode.Inhale

	def onModeInhale():
		pass

	def onModeCough():
		pass

	def onModeHold():
		pass

	def onModeExhale():
		pass

	def onAnimationEnd(anim as Animation):
		# Debug.Log("*** animation ended: anim=$(anim)")
		if anim.camera:
			Invoke("onIntroDone", delayAfterIntro)

	def onCough():
		currentMode = GameMode.Cough

	def onDoneCoughing():
		currentMode = GameMode.Inhale
