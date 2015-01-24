import UnityEngine

class LighterMove(MonoBehaviour):

	public handController as Animation
	public hand1 as Animation
	public hand2 as Animation
	public sparkRenderer as SpriteRenderer
	public sparkSprites as (Sprite)
	public sparkFps as single = 24
	public handRenderer as SpriteRenderer
	public handUnlit as Sprite
	public handLit as Sprite

	public maxY as single = 1
	public minY as single = 0.7
	public speed as single = 3
	public threshold as single = 0.6
	public ignitionDelay as single = 0.150

	shown as bool = false

	_lit = false
	lit:
		get:
			return _lit
		protected set:
			if _lit != value:
				_lit = value
				onLitChanged()

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
			# DebugScreen.logRow("hand1.pos=" + state.normalizedTime.ToString("0.##"))
			# DebugScreen.logRow("hand1.ready=$(readyToLight)")

		if shown:
			if Input.GetMouseButton(0):
				if Input.GetMouseButtonDown(0):
					ignite()
				pos = Input.mousePosition.y / Screen.height
				# DebugScreen.logRow("pos=$(pos)")
				desiredhandAnimPos = Mathf.InverseLerp(maxY, minY, pos)
				# DebugScreen.logRow("lighter.dpos=$(desiredhandAnimPos)")
			else:
				lit = false
				desiredhandAnimPos = 0
		else:
			desiredhandAnimPos = 0
		handAnimPos = Mathf.Lerp(handAnimPos, desiredhandAnimPos, speed * Time.deltaTime)
		for state as AnimationState in hand1:
			state.normalizedTime = handAnimPos
		for state as AnimationState in hand2:
			state.normalizedTime = handAnimPos

	def ignite():
		StopAllCoroutines()
		StartCoroutine(playSparks())
		Invoke("onIgnite", ignitionDelay)

	def onIgnite():
		lit = true

	def onLitChanged():
		handRenderer.sprite = (handLit if lit else handUnlit)
		if lit:
			pass
		else:
			StopAllCoroutines()
			sparkRenderer.sprite = sparkSprites[0]

	def playSparks() as IEnumerator:
		for sprite in sparkSprites:
			sparkRenderer.sprite = sprite
			yield WaitForSeconds(1 / sparkFps)
