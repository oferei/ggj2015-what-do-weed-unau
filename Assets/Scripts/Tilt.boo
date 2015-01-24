import UnityEngine

class Tilt(MonoBehaviour):

	public topAngle as single = -0.8
	public bottomAngle as single = -0.7
	public speed as single = 3
	public cameraTopAngle as single = 0
	public cameraBottomAngle as single = 15
	public cameraSmokeAngleThreshold as single = 13
	public lighter as LighterShow

	public debugScreen as DebugScreen
	public slider as UI.Slider

	relAngle as single = 1

	def Update():
		# debugScreen.logRow("accel=$(Input.acceleration)")
		debugScreen.logRow("tilt=$(Input.acceleration.y)")
		destination = Mathf.InverseLerp(bottomAngle, topAngle, Input.acceleration.y)
		destination = Mathf.SmoothStep(0, 1, destination)
		relAngle = Mathf.Lerp(relAngle, destination, speed * Time.deltaTime)
		slider.value = relAngle
		cameraAngle = Mathf.Lerp(cameraBottomAngle, cameraTopAngle, relAngle)
		Camera.main.transform.localEulerAngles.x = cameraAngle
		lighter.shown = cameraAngle >= cameraSmokeAngleThreshold
