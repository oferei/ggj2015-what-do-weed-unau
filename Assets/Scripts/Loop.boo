import UnityEngine

class Loop (MonoBehaviour): 

	public skipIntro = false
	public delayAfterIntro as single = 2.0
	public logoObject as GameObject
	public StartObject as GameObject
	public speechBubble as GameObject
	public welcomeTexts as (GameObject)
	public coughTexts as (GameObject)
	public successTexts as (GameObject)

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

	def Awake():
		currentMode = GameMode.Intro
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

		speechBubble.SetActive(currentMode == GameMode.Dialogue)

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
		# Debug.Log("*** dialogue: last=$(lastMode)")
		hideAllTexts()
		if lastMode == GameMode.Intro:
			welcomeTexts[0].SetActive(true)
		elif lastMode == GameMode.Cough:
			index = Random.Range(0, coughTexts.Length)
			coughTexts[index].SetActive(true)
		elif lastMode == GameMode.Exhale:
			index = Random.Range(0, successTexts.Length)
			successTexts[index].SetActive(true)

	def hideAllTexts():
		for obj in welcomeTexts + coughTexts + successTexts:
			obj.SetActive(false)

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

	def onWelcomeDone():
		currentMode = GameMode.Inhale

	def onCoughDone():
		currentMode = GameMode.Inhale

	def onSuccessDone():
		currentMode = GameMode.Inhale

	def onCough():
		currentMode = GameMode.Cough

	def onDoneCoughing():
		currentMode = GameMode.Dialogue
