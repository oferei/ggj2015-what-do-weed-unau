import UnityEngine

class Mic(MonoBehaviour):

	public bufSize as int = 1
	public sampleRate as int = 44100
	public maxInputAmp as single = 5000

	public averagingSampleSize as single = 0.3

	public volumeText as UI.Text
	public volumeBar as UI.Image

	clip as AudioClip

	def Start():
		Debug.Log("Microphone.Start")
		clip = Microphone.Start(null, true, bufSize, sampleRate)

		# aud as AudioSource = GetComponent[of AudioSource]()
		# aud.clip = Microphone.Start(null, true, 10, sampleRate)
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
			for i in range(averagingSampleSize * sampleRate):
				sum += Mathf.Abs(samples[srcIndex % numSamples])
				--srcIndex

			vol = Mathf.Clamp01(sum / maxInputAmp)
			vol = Mathf.Max(Mathf.Log(vol * 8, 2), 0)
			volumeBar.transform.localScale.y = vol
			volumeText.text = "pos=$(pos)\nsum=$(sum)\nvol=$(vol)"
