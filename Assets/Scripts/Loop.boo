import UnityEngine

class Loop (MonoBehaviour): 

	public skipIntro = false
	public delayAfterIntro as single = 2.0
	public logoObject as GameObject
	public StartObject as GameObject
	public speechBubble as GameObject
	public welcomeTexts as (GameObject)
	public coughTexts as (GameObject)
	public holdTexts as (GameObject)
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

	nextSuccessText as int = 0

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
		elif lastMode == GameMode.Hold:
			holdTexts[0].SetActive(true)
		elif lastMode == GameMode.Exhale:
			Debug.Log("*** nextSuccessText=$(nextSuccessText)")
			successTexts[nextSuccessText].SetActive(true)
			nextSuccessText = (nextSuccessText + 1) % successTexts.Length

	def hideAllTexts():
		for obj in welcomeTexts + coughTexts + holdTexts + successTexts:
			obj.SetActive(false)

	def onModeInhale():
		pass

	def onModeCough():
		pass

	def onModeHold():
		currentMode = GameMode.Dialogue

	def onModeExhale():
		currentMode = GameMode.Dialogue

	def onAnimationEnd(anim as Animation):
		# Debug.Log("*** animation ended: anim=$(anim)")
		if anim.camera:
			Invoke("onIntroDone", delayAfterIntro)

	def onWelcomeTextDone():
		currentMode = GameMode.Inhale

	def onCoughTextDone():
		currentMode = GameMode.Inhale

	def onHoldTextDone():
		currentMode = GameMode.Exhale

	def onSuccessTextDone():
		currentMode = GameMode.Inhale

	def onLungsFull():
		currentMode = GameMode.Hold

	def onCough():
		currentMode = GameMode.Cough

	def onDoneCoughing():
		currentMode = GameMode.Dialogue
