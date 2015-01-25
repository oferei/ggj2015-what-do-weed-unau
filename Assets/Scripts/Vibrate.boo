import UnityEngine

class Vibrate(MonoBehaviour):

	public updateInterval as single = 0.5

	OFF = 0
	ON = 1

	_strength as single = 0
	strength:
		get:
			return _strength
		set:
			_strength = value
			if _strength > 0:
				if not IsInvoking():
					InvokeRepeating("vibrate", 0, updateInterval)
			else:
				CancelInvoke()
				Vibration.Cancel()

	pattern as (long)

	def Awake():
		pattern = array[of long]((2))
		# pattern[OFF] = 100 # off
		pattern[ON] = 1 # on

	def vibrate():
		pattern[OFF] = Mathf.Lerp(300, 100, strength) # off
		# DebugScreen.logRow("vibrate=$(strength) off=$(pattern[OFF])")
		Vibration.Vibrate(pattern, 0)
