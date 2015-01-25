import UnityEngine

class Cough (MonoBehaviour): 

	public gameloop as Loop
	public particles as ParticleSystem
	public sound as AudioClip
	public duration as single = 5

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
		yield WaitForSeconds(duration)
		particles.gameObject.SetActive(false)
		gameloop.onDoneCoughing()
