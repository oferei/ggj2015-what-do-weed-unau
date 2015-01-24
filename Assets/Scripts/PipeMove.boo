import UnityEngine

class PipeMove(MonoBehaviour):

	public pipe as Animation

	def Awake():
		rewind()

	def rewind():
		pipe.wrapMode = WrapMode.ClampForever
		pipe.Play()
		pipe.Rewind()
		for state as AnimationState in pipe:
			state.speed = 0

	def OnEnable():
		God.inst.hermes.listen(MessageSmokeMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageSmokeMode, self)

	def Update():
		for state as AnimationState in pipe:
			state.normalizedTime = Mathf.Clamp01(state.normalizedTime)
			# DebugScreen.logRow("pipe.pos=$(state.normalizedTime)")

	def OnMsgSmokeMode(msg as MessageSmokeMode):
		# Debug.Log("Pipe: Received a smoke-mode message: ${msg.enabled}")
		if msg.enabled:
			for state as AnimationState in pipe:
				state.speed = 1
		else:
			for state as AnimationState in pipe:
				state.speed = -1
