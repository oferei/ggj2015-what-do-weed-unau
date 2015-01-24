import UnityEngine

class Inhale(MonoBehaviour):

	public breathDetect as BreathDetect
	public lighterMove as LighterMove
	public fanFactor as single = 1
	public lighterFactor as single = 1
	public chillFactor as single = 1
	public offThreshold as single = 0.01

	public flameSpriteRenderer as SpriteRenderer
	public flameSprites as (Sprite)
	public burnSpriteRenderer as SpriteRenderer
	public burnSprites as (Sprite)

	_burnLevel as single = 0
	burnLevel:
		get:
			return _burnLevel
		set:
			value = Mathf.Clamp01(value)
			if _burnLevel != value:
				_burnLevel = value
				onBurnLevelChanged()

	_inMode = false
	protected inMode:
		get:
			return _inMode
		set:
			if _inMode != value:
				_inMode = value
				oninModeChanged()

	offCheckEnabled = false

	def OnEnable():
		God.inst.hermes.listen(MessageMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageMode, self)

	def OnMsgMode(msg as MessageMode):
		# Debug.Log("mode: ${msg.mode}")
		inMode = msg.mode == GameMode.Mode.Inhale

	def oninModeChanged():
		# Debug.Log("*** inhaling=$(inMode)")
		pass

	def Update():
		DebugScreen.logRow("burn=$(burnLevel.ToString('0.##'))")
	# 	DebugScreen.logRow("in:breath=$(breathDetect.strength)")
	# 	DebugScreen.logRow("in:light=$(lighterMove.proximity.ToString('0.##'))")
	# 	DebugScreen.logRow("in:burn=$(burnLevel.ToString('0.##'))")

	def FixedUpdate():
		return if not inMode
		updateFlame()
		updateBurn()
		updateSmoke()

	def updateFlame():
		flameSuction = breathDetect.strength * lighterMove.proximity
		if lighterMove.lit:
			flameSpriteRenderer.sprite = flameSprites[flameSuction * flameSprites.Length]
		else:
			flameSpriteRenderer.sprite = null

	def updateBurn():
		increaseBurn()
		decreaseBurn()

		if offCheckEnabled:
			if burnLevel < offThreshold:
				offCheckEnabled = false
				burnLevel = 0
		else:
			if burnLevel > offThreshold:
				offCheckEnabled = true

	def onBurnLevelChanged():
		index = Mathf.FloorToInt(Mathf.Min(burnLevel, 0.999) * burnSprites.Length)
		burnSpriteRenderer.sprite = burnSprites[index]

	def increaseBurn():
		fanPower = (breathDetect.strength if burnLevel > 0 else 0) * fanFactor
		lighterPower = breathDetect.strength * lighterMove.proximity * lighterFactor
		heat = fanPower + lighterPower
		# if lighterMove.proximity:
		# 	Debug.Log("*** fanPower=$(fanPower) lighterPower=$(lighterPower)")
		burnLevel += heat * Time.deltaTime

	def decreaseBurn():
		burnLevel -= chillFactor * burnLevel * Time.deltaTime
		# Debug.Log("*** chillFactor=$(chillFactor) chillFactor * burnLevel=$(chillFactor * burnLevel)")

	def updateSmoke():
		pass
