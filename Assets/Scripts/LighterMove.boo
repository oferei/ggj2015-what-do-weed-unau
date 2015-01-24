import UnityEngine

class LighterMove(MonoBehaviour):

	public handController as Animation
	public hand1 as Animation
	public hand2 as Animation
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

		hand1.wrapMode = WrapMode.ClampForever
		hand1.Play()
		hand1.Rewind()
		for state as AnimationState in hand1:
			state.speed = 0

		hand2.wrapMode = WrapMode.ClampForever
		hand2.Play()
		hand2.Rewind()
		for state as AnimationState in hand2:
			state.speed = 0

		# flameAnim = flame.animation
		# flameAnim = flameSpriteRenderer.animation

		# flame.StartPlayback()
		# flame.speed = 0.1
		# flame.Play("Flame_Animation", -1, 1)

		# flameAnimation = Resources.Load[of AnimationClip]("Animations/Flame_Animation")
		# Debug.Log("*** flameAnimation=$(flameAnimation)")
		# Debug.Log("*** flameAnimation.length=$(flameAnimation.length)")

		# Debug.Log("flameAnim=$(flameAnim)")
		# flameAnim.Play()
		# flameSpriteRenderer.sprite = flameSprites[13]

		# overrideController as AnimatorOverrideController = AnimatorOverrideController()
		# flame.runtimeAnimatorController = overrideController

		spark.StartPlayback()
		# spark.playbackTime = 1
		# spark.StopPlayback()
		# stateInfo = spark.GetCurrentAnimatorStateInfo(0)
		# Debug.Log("*** stateInfo=$(stateInfo) length=$(stateInfo.length)")
		# spark.SetFloat('Speed', 1)

	def OnEnable():
		God.inst.hermes.listen(MessageSmokeMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageSmokeMode, self)

	def OnMsgSmokeMode(msg as MessageSmokeMode):
		# Debug.Log("Hand: Received a smoke-mode message: ${msg.enabled}")
		shown = msg.enabled
		for state as AnimationState in handController:
			state.speed = (1 if msg.enabled else -1)

	# def LateUpdate():
	# 	flameAnim = flame.animation
	# 	# Debug.Log("flameAnim=$(flameAnim)")
	# 	# flameAnim.wrapMode = WrapMode.ClampForever
	# 	# flameAnim.Play()
	# 	# flameAnim.Rewind()
	# 	for state as AnimationState in flameAnim:
	# 		state.speed = 0
	# 	flameAnim.Stop()

	def Update():
		# flameAnimState = flame.GetCurrentAnimatorStateInfo(0)
		# DebugScreen.logRow("flame=$(flameAnimState.normalizedTime)")

		spark.Update(Time.deltaTime)
		for state as AnimationState in handController:
			state.normalizedTime = Mathf.Clamp01(state.normalizedTime)
			# DebugScreen.logRow("hand1.pos=" + state.normalizedTime.ToString("0.##"))
			# DebugScreen.logRow("hand1.ready=$(readyToLight)")

		# DebugScreen.logRow("*** flame=$(flame.playbackTime)")
		# DebugScreen.logRow("*** spark=$(spark.playbackTime)")

		if shown:
			touch = Input.GetMouseButton(0)
			if not lit and touch:
				# Debug.Log("*** spark")
				pass
				# spark.Play("Spark")
				# spark.StartPlayback()
				# stateInfo = spark.GetCurrentAnimatorStateInfo(0)
				# Debug.Log("*** stateInfo=$(stateInfo) length=$(stateInfo.length)")
				# spark.CrossFade("Sparks", 0f)
				# settrigger
				# Animator.StringToHash('Jump')

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
		for state as AnimationState in hand1:
			state.normalizedTime = handAnimPos
		for state as AnimationState in hand2:
			state.normalizedTime = handAnimPos
