import UnityEngine

class BreathDetect(MonoBehaviour):

	public maxRms as single = 0.8
	public minRms as single = 0.0

	public mic as Mic

	_strength as single
	strength:
		get:
			return _strength

	def Update ():
		_strength = Mathf.InverseLerp(minRms, maxRms, mic.volumeRms)
		# DebugScreen.logRow("breath=$(strength)")
