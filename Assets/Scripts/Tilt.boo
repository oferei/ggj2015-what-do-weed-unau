import UnityEngine

class Tilt(MonoBehaviour):

	public topAngle as single = -0.8
	public bottomAngle as single = -0.7
	public speed as single = 3
	public cameraTopAngle as single = 0
	public cameraBottomAngle as single = 15
	public cameraSmokeAngleThreshold as single = 13
	public lighter as LighterMove
	public smoothTime as single = 2.0
	public maxSpeed as single = 0.5

	public debugScreen as DebugScreen
	public slider as UI.Slider

	smoothAngle as single = 1
	currentVelocity as single

	def Update():
		# debugScreen.logRow("accel=$(Input.acceleration)")
		debugScreen.logRow("tilt=$(Input.acceleration.y)")
		actualAngle = Mathf.InverseLerp(bottomAngle, topAngle, Input.acceleration.y)
		# actualAngle = Mathf.SmoothStep(0, 1, actualAngle)
		# smoothAngle = Mathf.Lerp(smoothAngle, actualAngle, speed * Time.deltaTime)
		# slider.value = smoothAngle
		smoothAngle = Mathf.SmoothDampAngle(smoothAngle, actualAngle, currentVelocity, smoothTime, maxSpeed)
		cameraAngle = Mathf.Lerp(cameraBottomAngle, cameraTopAngle, smoothAngle)
		Camera.main.transform.localEulerAngles.x = cameraAngle
		lighter.shown = cameraAngle >= cameraSmokeAngleThreshold
