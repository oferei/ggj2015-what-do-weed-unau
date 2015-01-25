import UnityEngine

class Vibrate(MonoBehaviour):

	public maxOff as int = 500
	public minOff as int = 100

	_strength as single = 0
	strength:
		get:
			return _strength
		set:
			_strength = value
			if _strength > 0:
				if not IsInvoking():
					vibrate()
			else:
				CancelInvoke()
				Vibration.Cancel()

	pattern as (long) = (0L, 1L, 0L) # off/on/off

	def vibrate():
		pattern[2] = Mathf.Lerp(maxOff, minOff, strength) # off
		# Debug.Log("vibrate=$(strength) off=$(pattern[2])")
		Vibration.Vibrate(pattern, 0)
		Invoke("vibrate", (1 + pattern[2]) cast single / 1000)
