﻿import UnityEngine

class Cough(MonoBehaviour):

	public gameloop as Loop
	public particles as ParticleSystem
	public vibrate as Vibrate
	public sound as AudioClip
	public duration as single = 5
	public pattern as (int)

	patternAsLongs as (long)

	vibrateHandle as int

	def Awake():
		patternAsLongs = array[of long]((pattern.Length))
		for i in range(pattern.Length):
			patternAsLongs[i] = pattern[i] cast long
		vibrateHandle = vibrate.nextHandle

	def OnEnable():
		God.inst.hermes.listen(MessageMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageMode, self)

	def OnMsgMode(msg as MessageMode):
		if msg.mode == GameMode.Cough:
			StartCoroutine(cough())

	def cough() as IEnumerator:
		audio.clip = sound
		audio.Play()
		particles.gameObject.SetActive(true)
		vibrate.pattern(vibrateHandle, patternAsLongs)
		yield WaitForSeconds(duration)
		particles.gameObject.SetActive(false)
		vibrate.stop(vibrateHandle)
		gameloop.onDoneCoughing()
