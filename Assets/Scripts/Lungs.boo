import UnityEngine

class Lungs(MonoBehaviour):

	count as int = 0

	def OnParticleCollision(other as GameObject):
		++count

	def Update():
		DebugScreen.logRow("smoke=$(count) t=$(Time.timeSinceLevelLoad)")
		DebugScreen.logRow("smoke=$(count/Time.timeSinceLevelLoad)")
