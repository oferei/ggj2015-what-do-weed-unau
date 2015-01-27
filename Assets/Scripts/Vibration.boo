# import UnityEngine

class Vibration:

	static final VIBRATOR_SERVICE = "vibrator"

	vibrator as AndroidJavaObject

	static _instance as Vibration
	protected static instance:
		get:
			if not _instance:
				_instance = Vibration()
			return _instance

	def constructor():
		ifdef UNITY_ANDROID and not UNITY_EDITOR:
			unityPlayer = AndroidJavaClass("com.unity3d.player.UnityPlayer")
			currentActivity = unityPlayer.GetStatic[of AndroidJavaObject]("currentActivity")
			vibrator = currentActivity.Call[of AndroidJavaObject]("getSystemService", VIBRATOR_SERVICE)
		ifdef not UNITY_ANDROID or UNITY_EDITOR:
			pass

	static def vibrate():
		instance._vibrate()

	def _vibrate():
		# this line is essential for granting VIBRATE permission
		Handheld.Vibrate()

	static def vibrate(milliseconds as long):
		instance._vibrate(milliseconds)

	def _vibrate(milliseconds as long):
		ifdef UNITY_ANDROID and not UNITY_EDITOR:
			vibrator.Call("vibrate", milliseconds)
		ifdef not UNITY_ANDROID or UNITY_EDITOR:
			pass

	static def vibrate(pattern as (long), repeat as int):
		instance._vibrate(pattern, repeat)

	def _vibrate(pattern as (long), repeat as int):
		ifdef UNITY_ANDROID and not UNITY_EDITOR:
			vibrator.Call("vibrate", pattern, repeat)
		ifdef not UNITY_ANDROID or UNITY_EDITOR:
			pass

	static def cancel():
		instance._cancel()

	def _cancel():
		ifdef UNITY_ANDROID and not UNITY_EDITOR:
			vibrator.Call("cancel")
		ifdef not UNITY_ANDROID or UNITY_EDITOR:
			pass
