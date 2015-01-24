import UnityEngine

class LighterMove(MonoBehaviour):

	public handController as Animation
	public hand as Animation

	public maxY as single = 1
	public minY as single = 0.7
	public speed as single = 3

	shown as bool = false

	handAnimPos as single = 0.0

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
			DebugScreen.logRow("hand.pos=" + state.normalizedTime.ToString("0.##"))
			DebugScreen.logRow("hand.ready=$(readyToLight)")

		if shown:
			if Input.GetMouseButton(0):
				pos = Input.mousePosition.y / Screen.height
				DebugScreen.logRow("pos=$(pos)")
				t = Mathf.InverseLerp(maxY, minY, pos)
				DebugScreen.logRow("t=$(t)")
				desiredhandAnimPos = t
			else:
				desiredhandAnimPos = 0
		else:
			desiredhandAnimPos = 0
		handAnimPos = Mathf.Lerp(handAnimPos, desiredhandAnimPos, speed * Time.deltaTime)
		for state as AnimationState in hand:
			state.normalizedTime = handAnimPos
