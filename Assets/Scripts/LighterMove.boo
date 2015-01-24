import UnityEngine

class LighterMove(MonoBehaviour):

	public handController as Animation
	public hand as Animation
	public spark as Animator

	public maxY as single = 1
	public minY as single = 0.7
	public speed as single = 3
	public threshold as single = 0.6

	shown as bool = false

	lit = false

	handAnimPos as single = 0.0

	proximity as single:
		get:
			return (Mathf.InverseLerp(threshold, 1, handAnimPos) if lit else 0)

	readyToLight as bool:
		get:
			for state as AnimationState in handController:
				return state.normalizedTime > 0.99

	def Awake():
		rewind()

	def rewind():
		handController.wrapMode = WrapMode.ClampForever
		handController.Play()
		handController.Rewind()
		for state as AnimationState in handController:
			state.speed = 0

		hand.wrapMode = WrapMode.ClampForever
		hand.Play()
		hand.Rewind()
		for state as AnimationState in hand:
			state.speed = 0

	def OnEnable():
		God.inst.hermes.listen(MessageSmokeMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageSmokeMode, self)

	def OnMsgSmokeMode(msg as MessageSmokeMode):
		# Debug.Log("Hand: Received a smoke-mode message: ${msg.enabled}")
		shown = msg.enabled
		for state as AnimationState in handController:
			state.speed = (1 if msg.enabled else -1)

	def Update():
		for state as AnimationState in handController:
			state.normalizedTime = Mathf.Clamp01(state.normalizedTime)
			# DebugScreen.logRow("hand.pos=" + state.normalizedTime.ToString("0.##"))
			# DebugScreen.logRow("hand.ready=$(readyToLight)")

		if shown:
			touch = Input.GetMouseButton(0)
			if not lit and touch:
				Debug.Log("*** spark")
			# spark
			lit = touch
			if lit:
				pos = Input.mousePosition.y / Screen.height
				# DebugScreen.logRow("pos=$(pos)")
				desiredhandAnimPos = Mathf.InverseLerp(maxY, minY, pos)
				# DebugScreen.logRow("lighter.dpos=$(desiredhandAnimPos)")
			else:
				desiredhandAnimPos = 0
		else:
			desiredhandAnimPos = 0
		handAnimPos = Mathf.Lerp(handAnimPos, desiredhandAnimPos, speed * Time.deltaTime)
		for state as AnimationState in hand:
			state.normalizedTime = handAnimPos
