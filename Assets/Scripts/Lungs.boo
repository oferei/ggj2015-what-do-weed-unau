import UnityEngine

class Lungs(MonoBehaviour):

	public maxCapacity as int = 1000
	public barMask as RectTransform
	public emptyValue as single = -1324
	public fullValue as single = -354
	public barSmoothTime as single = 0.5
	public barMaxSpeed as single = 1
	public depleteDelay as single = 2.0
	public depleteRate as single = 1

	desiredValue as single = emptyValue

	_totalSmokeCount as int = 0
	totalSmokeCount:
		get:
			return _totalSmokeCount
		set:
			_totalSmokeCount = Mathf.Clamp(value, 0, maxCapacity)

	barCurrentVelocity as single = 0

	lastInput as single = 0
	toDeplete as single = 0

	def Awake():
		barMask.offsetMax.y = desiredValue

	def OnParticleCollision(other as GameObject):
		lastInput = Time.time
		++totalSmokeCount

	def FixedUpdate():
		if Time.time - lastInput > depleteDelay:
			toDeplete += depleteRate * Time.deltaTime
			if toDeplete > 1:
				totalSmokeCount -= Mathf.Floor(toDeplete)
				toDeplete -= Mathf.Floor(toDeplete)

	def Update():
		full as single = (totalSmokeCount cast single) / maxCapacity
		DebugScreen.logRow("lungs=$(totalSmokeCount) ($((full * 100).ToString('0.#'))%)")
		# DebugScreen.logRow("smoke=$(totalSmokeCount/Time.timeSinceLevelLoad)")
		desiredValue = Mathf.Lerp(emptyValue, fullValue, full)
		barMask.offsetMax.y = Mathf.SmoothDamp(barMask.offsetMax.y, desiredValue, barCurrentVelocity, barSmoothTime, barMaxSpeed)
