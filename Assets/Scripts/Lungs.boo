import UnityEngine

class Lungs(MonoBehaviour):

	public maxCapacity as int = 1000
	public barMask as RectTransform
	public emptyValue as single = -1324
	public fullValue as single = -354
	public barSmoothTime as single = 0.5
	public barMaxSpeed as single = 1

	desiredValue as single = emptyValue

	totalSmokeCount as int = 0
	barCurrentVelocity as single = 0

	def Awake():
		barMask.offsetMax.y = desiredValue

	def OnParticleCollision(other as GameObject):
		++totalSmokeCount

	def Update():
		DebugScreen.logRow("lungs=$(totalSmokeCount)")
		# DebugScreen.logRow("smoke=$(totalSmokeCount/Time.timeSinceLevelLoad)")
		full as single = (totalSmokeCount cast single) / maxCapacity
		# DebugScreen.logRow("full=$(full)")
		desiredValue = Mathf.Lerp(emptyValue, fullValue, full)
		barMask.offsetMax.y = Mathf.SmoothDamp(barMask.offsetMax.y, desiredValue, barCurrentVelocity, barSmoothTime, barMaxSpeed)
