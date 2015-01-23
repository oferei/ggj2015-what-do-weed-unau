import UnityEngine

class Tilt(MonoBehaviour):

	public topAngle as single = -0.8
	public bottomAngle as single = -0.7
	public speed as single = 3

	public debugScreen as DebugScreen
	public slider as UI.Slider

	def Update():
		debugScreen.logRow("accel=$(Input.acceleration)")
		debugScreen.logRow("tilt=$(Input.acceleration.y)")
		destination = Mathf.InverseLerp(bottomAngle, topAngle, Input.acceleration.y)
		destination = Mathf.SmoothStep(0, 1, destination)
		slider.value = Mathf.Lerp(slider.value, destination, speed * Time.deltaTime)
