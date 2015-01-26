import UnityEngine

class AutoDimVolume(MonoBehaviour):

	public normalVolume as single = 1.0
	public dimmedVolume as single = 0.3
	public smoothTime as single = 1.0
	public maxSpeed as single = 1.0

	desiredVolume = dimmedVolume
	currentVelocity as single

	def OnEnable():
		God.inst.hermes.listen(MessageMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageMode, self)

	def OnMsgMode(msg as MessageMode):
		desiredVolume = (dimmedVolume if needToBeQuiet(msg.mode) else normalVolume)

	def needToBeQuiet(mode as GameMode):
		return mode == GameMode.Inhale or mode == GameMode.Hold or mode == GameMode.Exhale

	def Update():
		audio.volume = Mathf.SmoothDamp(audio.volume, desiredVolume, currentVelocity, smoothTime, maxSpeed)
