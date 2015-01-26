# import UnityEngine

class Vibration(MonoBehaviour):

	VIBRATOR_SERVICE = "vibrator"

	unityPlayer as AndroidJavaClass
	currentActivity as AndroidJavaObject
	vibrator as AndroidJavaObject
	cls as AndroidJavaObject
	clsName as string

	lastError as string = "<no error>"

	static instance as Vibration

	def Awake():
		connectToJava()

	def connectToJava():
		ifdef UNITY_ANDROID and not UNITY_EDITOR:
			try:
				unityPlayer = AndroidJavaClass("com.unity3d.player.UnityPlayer")
				currentActivity = unityPlayer.GetStatic[of AndroidJavaObject]("currentActivity")
				vibrator = currentActivity.Call[of AndroidJavaObject]("getSystemService", VIBRATOR_SERVICE)
				# cls = vibrator.Call[of AndroidJavaObject]("getClass")
				# clsName = vibrator.Call[of string]("getName")
				instance = self
			except e:
				lastError = "connect: $(e)"

	def Update():
		ifdef UNITY_ANDROID and not UNITY_EDITOR:
			DebugScreen.logRow("Vibration.Update (Android)")
		ifdef not UNITY_ANDROID or UNITY_EDITOR:
			DebugScreen.logRow("Vibration.Update (not Android)")
		DebugScreen.logRow("unityPlayer=$(unityPlayer)")
		DebugScreen.logRow("currentActivity=$(currentActivity)")
		DebugScreen.logRow("vibrator=$(vibrator)")
		DebugScreen.logRow("cls=$(cls)")
		DebugScreen.logRow("clsName=$(clsName)")
		DebugScreen.logRow("lastError=$(lastError)")

	static def Vibrate():
		instance._Vibrate()

	def _Vibrate():
		# this line must be called to enabled VIBRATE permission
		Handheld.Vibrate()

	static def Vibrate(milliseconds as long):
		instance._Vibrate(milliseconds)

	def _Vibrate(milliseconds as long):
		try:
			ifdef UNITY_ANDROID and not UNITY_EDITOR:
				connectToJava()
				vibrator.Call("vibrate", milliseconds)
			ifdef not UNITY_ANDROID or UNITY_EDITOR:
				pass
		except e:
			lastError = "Vibrate ms: $(e)"

	static def Vibrate(pattern as (long), repeat as int):
		instance._Vibrate(pattern, repeat)

	def _Vibrate(pattern as (long), repeat as int):
		try:
			ifdef UNITY_ANDROID and not UNITY_EDITOR:
				vibrator.Call("vibrate", pattern, repeat)
			ifdef not UNITY_ANDROID or UNITY_EDITOR:
				pass
		except e:
			lastError = "Vibrate p: $(e)"

	static def Cancel():
		instance._Cancel()

	def _Cancel():
		try:
			ifdef UNITY_ANDROID and not UNITY_EDITOR:
				vibrator.Call("cancel")
			ifdef not UNITY_ANDROID or UNITY_EDITOR:
				pass
		except e:
			lastError = "Vibrate cancel: $(e)"
