import UnityEngine

class Mic(MonoBehaviour):

	public volumeText as UI.Text

	clip as AudioClip

	def Start():
		Debug.Log("Microphone.Start")
		clip = Microphone.Start(null, true, 1, 44100)

		# aud as AudioSource = GetComponent[of AudioSource]()
		# aud.clip = Microphone.Start(null, true, 10, 44100)
		# aud.Play()

	def Update():
		pos = Microphone.GetPosition(null)
		# volumeText.text = "pos=$(pos)"
		# volumeText.text = "clip.channels=$(clip.channels)"
		if pos > 0:
			samples = array[of single]((clip.samples * clip.channels))
			clip.GetData(samples, pos)
			sum = 0.0
			for sample in samples:
				sum += Mathf.Abs(sample)
			volumeText.text = "pos=$(pos)\nsum=$(sum)"
