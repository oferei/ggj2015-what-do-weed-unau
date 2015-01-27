import UnityEngine

class Vibrate(MonoBehaviour):

	public maxOff as int = 500
	public minOff as int = 100

	enum Mode:
		Off
		Pulse
		Custom

	mode = Mode.Off

	handles = Generic.HashSet[of int]()

	_nextHandle as int = 1
	nextHandle:
		get:
			return _nextHandle++

	pulseStrength as single = 0

	def pulse(handle as int, strength as single):
		handles.Add(handle)
		if strength > 0:
			pulseStrength = strength
			mode = Mode.Pulse
			if not IsInvoking():
				vibrate()
		else:
			stop(handle)

	def pattern(handle as int, pattern as (long)):
		handles.Add(handle)
		mode = Mode.Custom
		CancelInvoke()
		Vibration.vibrate(pattern, 0)

	def stop(handle as int):
		if handle not in handles:
			return
		handles.Remove(handle)

		if handles.Count > 0:
			# Debug.Log("*** not closing vibration - another handle uses it")
			return

		return if mode == Mode.Off
		mode = Mode.Off
		CancelInvoke()
		StartCoroutine(cancelVibration())

	def cancelVibration() as IEnumerator:
		yield
		if mode == Mode.Off:
			Vibration.cancel()

	def vibrate():
		length as long = Mathf.Lerp(maxOff, minOff, pulseStrength)
		simplePattern = (0L, 1L, length)
		# Debug.Log("vibrate=$(pulseStrength) off=$(simplePattern[2])")
		Vibration.vibrate(simplePattern, 0)
		Invoke("vibrate", (1 + simplePattern[2]) cast single / 1000)
