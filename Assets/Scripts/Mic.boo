import UnityEngine

class Mic(MonoBehaviour):

	public bufSize as int = 1
	public sampleSize as single = 0.3

	public volumeText as UI.Text
	public volumeBar as UI.Image

	clip as AudioClip

	def Start():
		Debug.Log("Microphone.Start")
		clip = Microphone.Start(null, true, bufSize, 44100)

		# aud as AudioSource = GetComponent[of AudioSource]()
		# aud.clip = Microphone.Start(null, true, 10, 44100)
		# aud.Play()

	def Update():
		pos = Microphone.GetPosition(null)
		# volumeText.text = "pos=$(pos)"
		# volumeText.text = "clip.channels=$(clip.channels)"
		if pos > 0:
			samples = array[of single]((clip.samples * clip.channels))
			clip.GetData(samples, 0)
			sum as single = 0.0
			# samples2 = array[of single]((clip.samples * clip.channels))
			# samples.Copy(0, samples2, 0, 1)
			# for sample in samples:
				# sum += Mathf.Abs(sample)
			srcIndex = pos
			numSamples = len(samples)
			for i in range(sampleSize * 44100):
				sum += Mathf.Abs(samples[srcIndex % numSamples])
				--srcIndex

			vol = Mathf.Clamp01(sum / 10000.0)
			vol = Mathf.Log(vol * 1000, 10)
			volumeBar.transform.localScale.y = vol
			volumeText.text = "pos=$(pos)\nsum=$(sum)\nvol=$(vol)"
