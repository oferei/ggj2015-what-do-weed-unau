import UnityEngine

class Exhale(MonoBehaviour):

	public monitorPeriod as single = 1
	public threshold as single = 0.5
	public breathDetect as BreathDetect

	public gameloop as Loop
	public particles as ParticleSystem
	public maxSmokeTime as single = 6.4
	public stillBlowingTime as single = 5
	public extraTime as single = 5

	_inMode = false
	protected inMode:
		get:
			return _inMode
		set:
			if _inMode != value:
				_inMode = value
				oninModeChanged()

	monitoring = false

	class BreathRecord:
		property strength as single
		property time as single

	breaths = Generic.Queue[of BreathRecord]()

	def OnEnable():
		God.inst.hermes.listen(MessageMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageMode, self)

	def OnMsgMode(msg as MessageMode):
		inMode = msg.mode == GameMode.Exhale

	def oninModeChanged():
		if inMode:
			breaths.Clear()
			monitoring = true
		else:
			monitoring = false

	def Update():
		return unless monitoring
		recordBreath()
		monitorStrength()

	def recordBreath():
		now = Time.time
		breaths.Enqueue(BreathRecord(strength: breathDetect.exhaleStrength * Time.deltaTime, time: now))
		earliestBreathTime = now - monitorPeriod
		while breaths.Peek().time < earliestBreathTime:
			breaths.Dequeue()

	def monitorStrength():
		sum as single = 0
		for breath in breaths:
			sum += breath.strength
		totalStrength = sum / monitorPeriod
		# DebugScreen.logRow("exhale=$(totalStrength)")
		if totalStrength >= threshold:
			monitoring = false
			StartCoroutine(exhale())

	def exhale() as IEnumerator:
		particles.gameObject.SetActive(true)
		yield WaitForSeconds(maxSmokeTime)
		gameloop.onExhaleObscuresEverything()
		yield WaitForSeconds(stillBlowingTime)
		gameloop.onExhaleDone()
		yield WaitForSeconds(extraTime)
		particles.gameObject.SetActive(false)
