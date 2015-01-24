import UnityEngine

class Inhale(MonoBehaviour):

	public breathDetect as BreathDetect
	public lighterMove as LighterMove
	public heatFactor as single = 1
	public chillFactor as single = 1

	public flameSpriteRenderer as SpriteRenderer
	public flameSprites as (Sprite)

	burnLevel as single = 0

	_inMode = false
	protected inMode:
		get:
			return _inMode
		set:
			if _inMode != value:
				_inMode = value
				oninModeChanged()

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

	# def Update():
	# 	DebugScreen.logRow("in:breath=$(breathDetect.strength)")
	# 	DebugScreen.logRow("in:light=$(lighterMove.proximity.ToString('0.##'))")
	# 	DebugScreen.logRow("in:burn=$(burnLevel.ToString('0.##'))")

	def FixedUpdate():
		return if not inMode
		updateBurn()
		updateSmoke()

	def updateBurn():
		increaseBurn()
		decreaseBurn()
		burnLevel = Mathf.Clamp01(burnLevel)

	def increaseBurn():
		breathFactor = breathDetect.strength
		lighterFactor = Mathf.Lerp(1, 3, lighterMove.proximity)
		heat = breathFactor * lighterFactor / 3
		flameSpriteRenderer.sprite = flameSprites[heat * 21]
		burnLevel += heat * heatFactor * Time.deltaTime

	def decreaseBurn():
		burnLevel -= chillFactor * Time.deltaTime

	def updateSmoke():
		pass
