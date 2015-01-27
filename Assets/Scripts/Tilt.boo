import UnityEngine

class Tilt(MonoBehaviour):

	public topAngle as single = -0.8
	public bottomAngle as single = -0.7
	public speed as single = 3
	public cameraTopAngle as single = 0
	public cameraBottomAngle as single = 15
	public cameraSmokeAngleThreshold as single = 13
	public cameraUnsmokeAngleThreshold as single = 10
	public smoothTime as single = 2.0
	public maxSpeed as single = 0.5

	public debugScreen as DebugScreen
	public slider as UI.Slider

	manualTilt = false

	smoothAngle as single = 1
	currentVelocity as single

	_inhaleMode = false

	_smokeMode = false
	smokeMode:
		get:
			return _smokeMode
		set:
			if _smokeMode != value:
				_smokeMode = value
				MessageSmokeMode(_smokeMode)

	def Awake():
		manualTilt = Application.platform == RuntimePlatform.WindowsEditor or Application.platform == RuntimePlatform.OSXEditor

	def OnEnable():
		God.inst.hermes.listen(MessageMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageMode, self)

	def OnMsgMode(msg as MessageMode):
		_inhaleMode = msg.mode == GameMode.Inhale
		if not _inhaleMode:
			smokeMode = false

	def Update():
		if _inhaleMode:
			if manualTilt:
				deviceAngle = slider.value
			else:
				# debugScreen.logRow("accel=$(Input.acceleration)")
				if Input.acceleration.z < 0:
					deviceAngle = Mathf.InverseLerp(bottomAngle, topAngle, Input.acceleration.y)
				else:
					deviceAngle = 1
				# debugScreen.logRow("angle=$(deviceAngle)")
		else:
			deviceAngle = 1

		slider.value = deviceAngle
		smoothAngle = Mathf.SmoothDampAngle(smoothAngle, deviceAngle, currentVelocity, smoothTime, maxSpeed)
		# debugScreen.logRow("smoothAngle=$(smoothAngle)")

		cameraAngle = Mathf.Lerp(cameraBottomAngle, cameraTopAngle, smoothAngle)
		Camera.main.transform.localEulerAngles.x = cameraAngle

		threshold = (cameraUnsmokeAngleThreshold if smokeMode else cameraSmokeAngleThreshold)
		smokeMode = _inhaleMode and cameraAngle >= threshold
