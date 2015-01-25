import UnityEngine

class Lungs(MonoBehaviour):

	public maxCapacity as int = 1000
	public barMask as RectTransform
	public emptyValue = -1324

	fullValue as single

	count as int = 0

	def Awake():
		fullValue = barMask.offsetMax.y

	def OnParticleCollision(other as GameObject):
		++count

	def Update():
		# DebugScreen.logRow("smoke=$(count) t=$(Time.timeSinceLevelLoad)")
		# DebugScreen.logRow("smoke=$(count/Time.timeSinceLevelLoad)")
		full as single = (count cast single) / maxCapacity
		# DebugScreen.logRow("full=$(full)")
		barMask.offsetMax.y = Mathf.Lerp(emptyValue, fullValue, full)
