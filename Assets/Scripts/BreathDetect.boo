import UnityEngine

class BreathDetect(MonoBehaviour):

	public maxVolume as single = 0.8
	public minVolume as single = 0.0

	public mic as Mic

	_strength as single
	strength:
		get:
			return _strength

	def Update ():
		_strength = Mathf.InverseLerp(minVolume, maxVolume, mic.volume)
		# DebugScreen.logRow("breath=$(strength)")
