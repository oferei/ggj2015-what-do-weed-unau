﻿import UnityEngine

class Tilt(MonoBehaviour):

	public topAngle as single = -0.8
	public bottomAngle as single = -0.7
	public speed as single = 3
	public cameraTopAngle as single = 0
	public cameraBottomAngle as single = 15
	public cameraSmokeAngleThreshold as single = 13
	public smoothTime as single = 2.0
	public maxSpeed as single = 0.5

	public debugScreen as DebugScreen
	public slider as UI.Slider

	manualTilt = false

	smoothAngle as single = 1
	currentVelocity as single

	_smokeMode = false
	smokeMode:
		set:
			if _smokeMode != value:
				_smokeMode = value
				MessageSmokeMode(_smokeMode)

	def Awake():
		manualTilt = Application.platform == RuntimePlatform.WindowsEditor or Application.platform == RuntimePlatform.OSXEditor

	def Update():
		if manualTilt:
			smoothAngle = slider.value
		else:
			# debugScreen.logRow("accel=$(Input.acceleration)")
			debugScreen.logRow("tilt=$(Input.acceleration.y)")
			actualAngle = Mathf.InverseLerp(bottomAngle, topAngle, Input.acceleration.y)
			debugScreen.logRow("actualAngle=$(actualAngle)")
			smoothAngle = Mathf.SmoothDampAngle(smoothAngle, actualAngle, currentVelocity, smoothTime, maxSpeed)
			debugScreen.logRow("smoothAngle=$(smoothAngle)")
			slider.value = smoothAngle
		cameraAngle = Mathf.Lerp(cameraBottomAngle, cameraTopAngle, smoothAngle)
		Camera.main.transform.localEulerAngles.x = cameraAngle
		smokeMode = cameraAngle >= cameraSmokeAngleThreshold
