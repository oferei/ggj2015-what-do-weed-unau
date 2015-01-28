import UnityEngine

class Mic(MonoBehaviour):

	public bufSizeInSecs as int = 1
	public sampleRate as int = 44100
	public windowSizeInSecs as single = 0.3
	public spectrumSampleSize as int = 1024 # pow of 2, 64 to 8192
	public fftWindow as FFTWindow = FFTWindow.BlackmanHarris
	public minAmp as single = 0.02
	public volumeBar as UI.Image

	deviceName as string = null

	mixerSampleRate as single
	maxFreq as single

	visualHeight as single = 20

	clip as AudioClip

	samples as (single)
	samplesUpToDate = false

	spectrum as (single)
	spectrumUpToDate = false

	_loudnessRms as single = 0
	loudnessRms:
		get:
			if not loudnessRmsUpToDate:
				updateLoudnessRms()
			return _loudnessRms
		set:
			_loudnessRms = value
			volumeBar.transform.localScale.y = _loudnessRms
	loudnessRmsUpToDate = false

	loudnessDb:
		get:
			return 20 * Mathf.Log10(_loudnessRms)

	def Awake():
		spectrum = array(single, spectrumSampleSize)
		mixerSampleRate = AudioSettings.outputSampleRate
		# Debug.Log("AudioSettings.outputSampleRate=$(AudioSettings.outputSampleRate)")
		maxFreq = mixerSampleRate / 2

	def Start():
		clip = Microphone.Start(deviceName, true, bufSizeInSecs, sampleRate)
		samples = array[of single]((clip.samples * clip.channels))
		audio.clip = clip
		audio.loop = true
		audio.mute = true
		audio.Play()

	def Update():
		# pass
		# DebugScreen.logRow("mic.rms=$(loudnessRms.ToString('0.##'))")

		# spectrum
		drawSpectrum()
		# loudness = loudnessBetween(0, 22050)
		# loudness = loudnessBetween(500, 600)
		# DebugScreen.logRow("loudness=$(loudness.ToString('0.##'))")
		# loudness = loudnessAbove(12000)
		# DebugScreen.logRow("loudness=$(loudness.ToString('0.##'))")
		# pitch = calcPitch()
		# DebugScreen.logRow("pitch=$(pitch.ToString('0.#'))hz")

	def LateUpdate():
		samplesUpToDate = false
		spectrumUpToDate = false
		loudnessRmsUpToDate = false

	def updateSamples():
		if not samplesUpToDate:
			clip.GetData(samples, 0)
			# note: samples are between -1 and 1
			samplesUpToDate = true

	def updateLoudnessRms():
		updateSamples()
		pos = Microphone.GetPosition(deviceName)
		# DebugScreen.logRow("mic.pos=$(pos)")
		# samples = array[of single]((clip.samples * clip.channels))
		sum as single = 0.0
		srcIndex = pos
		numSamples = len(samples)
		numSamplesInWindow = windowSizeInSecs * sampleRate
		for i in range(numSamplesInWindow):
			sum += Mathf.Pow(samples[(srcIndex + numSamples) % numSamples], 2)
			--srcIndex
		loudnessRms = Mathf.Sqrt(sum / numSamplesInWindow)

	def updateSpectrum():
		if not spectrumUpToDate:
			audio.GetSpectrumData(spectrum, 0, fftWindow)
			# note: spectrum data are between 0 and ~0.56 (?)
			spectrumUpToDate = true

	def drawSpectrum():
		updateSpectrum()
		xFactor = spectrumSampleSize cast single / Mathf.Log(spectrumSampleSize)
		for f in range(1, maxFreq, 5000):
			x as single = (Mathf.Log((f cast single) * spectrumSampleSize / maxFreq) * xFactor)
			Debug.DrawLine(Vector3(x, -242, 0), Vector3(x, -252, 0), Color.green)
			x = f * spectrumSampleSize / maxFreq
			Debug.DrawLine(Vector3(x, 431, 0), Vector3(x, 421, 0), Color.red)
		for i in range(1, spectrumSampleSize):
			Debug.DrawLine(Vector3(i - 1, (spectrum[i - 1]) * 173 * visualHeight + 231 * 2, 0), Vector3(i, (spectrum[i]) * 173 * visualHeight + 231 * 2, 0), Color.red)
			Debug.DrawLine(Vector3(i - 1, (Mathf.Log(spectrum[i - 1])) * visualHeight + 231 * 2, 2), Vector3(i, (Mathf.Log(spectrum[i])) * visualHeight + 231 * 2, 2), Color.cyan)
			Debug.DrawLine(Vector3(Mathf.Log(i - 1) * xFactor, (spectrum[i - 1] * 95) * visualHeight - 231, 1), Vector3(Mathf.Log(i) * xFactor, (spectrum[i] * 95) * visualHeight - 231, 1), Color.green)
			Debug.DrawLine(Vector3(Mathf.Log(i - 1) * xFactor, Mathf.Log(spectrum[i - 1]) * visualHeight - 231, 3), Vector3(Mathf.Log(i) * xFactor, Mathf.Log(spectrum[i]) * visualHeight - 231, 3), Color.yellow)

	def loudnessBetween(low as single, high as single):
		updateSpectrum()

		low = Mathf.Clamp(low, 0, maxFreq)
		high = Mathf.Clamp(high, low, maxFreq)

		lowIndex = Mathf.FloorToInt((low cast single) * spectrumSampleSize / maxFreq)
		lowIndex = Mathf.Min(lowIndex, spectrumSampleSize - 1)
		highIndex = Mathf.FloorToInt((high cast single) * spectrumSampleSize / maxFreq)
		highIndex = Mathf.Min(highIndex, spectrumSampleSize - 1)

		sum as single = 0.0
		for i in range(lowIndex, highIndex + 1):
			sum += spectrum[i]
		loudness = sum / (highIndex - lowIndex + 1)

		return loudness

	def loudnessAbove(low as single):
		return loudnessBetween(low, maxFreq)

	def loudnessBelow(high as single):
		return loudnessBetween(0, high)

	def pitchBetween(low as single, high as single):
		updateSpectrum()

		low = Mathf.Clamp(low, 0, maxFreq)
		high = Mathf.Clamp(high, low, maxFreq)

		lowIndex = Mathf.FloorToInt((low cast single) * spectrumSampleSize / maxFreq)
		lowIndex = Mathf.Min(lowIndex, spectrumSampleSize - 1)
		highIndex = Mathf.FloorToInt((high cast single) * spectrumSampleSize / maxFreq)
		highIndex = Mathf.Min(highIndex, spectrumSampleSize - 1)

		maxI as int = -1
		maxSample as single = -1
		for i in range(lowIndex, highIndex + 1):
			if spectrum[i] > minAmp and spectrum[i] > maxSample:
				maxSample = spectrum[i]
				maxI = i

		if maxI == -1:
			return 0

		# interpolate index using neighbours
		indexF = maxI cast single
		if maxI > 0 and maxI < spectrumSampleSize - 1:
			dL = spectrum[maxI - 1] / spectrum[maxI]
			dR = spectrum[maxI + 1] / spectrum[maxI]
			indexF += 0.5 * (dR * dR - dL * dL)

		return indexF * maxFreq / spectrumSampleSize

	def pitchAbove(low as single):
		return pitchBetween(low, maxFreq)

	def pitchBelow(high as single):
		return pitchBetween(0, high)

	def pitch():
		return pitchBetween(0, maxFreq)
