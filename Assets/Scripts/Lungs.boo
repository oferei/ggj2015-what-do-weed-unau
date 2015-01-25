import UnityEngine
import System.Collections

class Lungs(MonoBehaviour):

	public maxCapacity as int = 1000
	public monitorPeriod as single = 2
	public maxIntake as int = 10
	public depleteDelay as single = 2.0
	public depleteRate as single = 1
	public barObject as GameObject
	public barMask as RectTransform
	public emptyValue as single = -1324
	public fullValue as single = -354
	public barSmoothTime as single = 0.5
	public barMaxSpeed as single = 1
	public gameloop as Loop
	public lighter as Lighter

	desiredValue as single = emptyValue

	_totalSmokeCount as int = 0
	totalSmokeCount:
		get:
			return _totalSmokeCount
		set:
			_totalSmokeCount = Mathf.Clamp(value, 0, maxCapacity)
			if _totalSmokeCount >= maxCapacity:
				gameloop.onLungsFull()

	barCurrentVelocity as single = 0

	lastInput as single = 0
	toDeplete as single = 0

	lastIntakes = Generic.Queue[of single]()

	def Awake():
		barMask.offsetMax.y = desiredValue

	def OnEnable():
		God.inst.hermes.listen(MessageSmokeMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageSmokeMode, self)

	def OnMsgSmokeMode(msg as MessageSmokeMode):
		collider.enabled = msg.enabled

	def OnParticleCollision(other as GameObject):
		now = Time.time
		lastIntakes.Enqueue(now)
		lastInput = now
		++totalSmokeCount

	def FixedUpdate():
		if Time.time - lastInput > depleteDelay:
			toDeplete += depleteRate * Time.deltaTime
			if toDeplete > 1:
				totalSmokeCount -= Mathf.Floor(toDeplete)
				toDeplete -= Mathf.Floor(toDeplete)

	def Update():
		barObject.SetActive(lighter.readyToLight)
		monitorIntake()
		updateBar()

	def monitorIntake():
		earliestIntakeTime = Time.time - monitorPeriod
		while lastIntakes.Count > 0 and lastIntakes.Peek() < earliestIntakeTime:
			lastIntakes.Dequeue()
		intake = lastIntakes.Count
		DebugScreen.logRow("intake=$(intake)")
		if intake > maxIntake:
			totalSmokeCount = 0
			lastIntakes.Clear()
			Debug.Log("You took too much man, you took too much, too much!")
			gameloop.onCough()

	def updateBar():
		full as single = (totalSmokeCount cast single) / maxCapacity
		DebugScreen.logRow("lungs=$(totalSmokeCount) ($((full * 100).ToString('0.#'))%)")
		# DebugScreen.logRow("smoke=$(totalSmokeCount/Time.timeSinceLevelLoad)")
		desiredValue = Mathf.Lerp(emptyValue, fullValue, full)
		barMask.offsetMax.y = Mathf.SmoothDamp(barMask.offsetMax.y, desiredValue, barCurrentVelocity, barSmoothTime, barMaxSpeed)
