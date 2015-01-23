import UnityEngine

class Tilt(MonoBehaviour):

	public topAngle as single = -0.8
	public bottomAngle as single = -0.7
	public speed as single = 3
	public cameraTopAngle as single = 0
	public cameraBottomAngle as single = 15

	public debugScreen as DebugScreen
	public slider as UI.Slider

	def Update():
		debugScreen.logRow("accel=$(Input.acceleration)")
		debugScreen.logRow("tilt=$(Input.acceleration.y)")
		destination = Mathf.InverseLerp(bottomAngle, topAngle, Input.acceleration.y)
		destination = Mathf.SmoothStep(0, 1, destination)
		angle = Mathf.Lerp(slider.value, destination, speed * Time.deltaTime)
		slider.value = angle
		Camera.main.transform.localEulerAngles.x = Mathf.Lerp(cameraBottomAngle, cameraTopAngle, angle)
