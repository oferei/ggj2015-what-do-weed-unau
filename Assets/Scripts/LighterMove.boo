import UnityEngine

class LighterMove(MonoBehaviour):

	public handController as Animation
	public hand as Animation

	public maxY as single = 1
	public minY as single = 0.7
	public speed as single = 3

	_shown as bool = false
	shown:
		get:
			return _shown
		set:
			if _shown != value:
				_shown = value
				onShownChanged()

	handControllerAnimPos as single = 0.0
	handAnimPos as single = 0.0

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
		if msg.enabled:
			for state as AnimationState in handController:
				state.speed = 1
		else:
			for state as AnimationState in handController:
				state.speed = -1

	def Update():
		for state as AnimationState in handController:
			state.normalizedTime = Mathf.Clamp01(state.normalizedTime)
			# DebugScreen.logRow("hand.pos=$(state.normalizedTime)")

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

	def onShownChanged():
		Debug.Log("*** shown=" + shown)
		if shown:
			handController.Play()
		# else:
		# 	handController.
