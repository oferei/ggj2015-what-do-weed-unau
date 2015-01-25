import UnityEngine

class Inhale(MonoBehaviour):

	public breathDetect as BreathDetect
	public lighter as Lighter
	public fanFactor as single = 1
	public lighterFactor as single = 1
	public chillFactor as single = 1
	public offThreshold as single = 0.01

	public flameSpriteRenderer as SpriteRenderer
	public flameSprites as (Sprite)
	public flameFlickerDuration as single = 0.05
	public flameFlickerChance as single = 0.5
	public burnSpriteRenderer as SpriteRenderer
	public burnSprites as (Sprite)

	public smokeParticleSystem as ParticleSystem
	public smokeVelocities as (single)
	public smokeEmissionRates as (single)
	public smokeTintAlphas as (single)

	_burnLevel as single = 0
	burnLevel:
		get:
			return _burnLevel
		set:
			value = Mathf.Clamp01(value)
			if _burnLevel != value:
				_burnLevel = value
				onBurnLevelChanged()

	_inMode = false
	protected inMode:
		get:
			return _inMode
		set:
			if _inMode != value:
				_inMode = value
				oninModeChanged()

	offCheckEnabled = false
	lastFlickerTime as single = 0

	def OnEnable():
		God.inst.hermes.listen(MessageMode, self)
	def OnDisable():
		God.inst.hermes.stopListening(MessageMode, self)

	def OnMsgMode(msg as MessageMode):
		inMode = msg.mode == GameMode.Inhale

	def oninModeChanged():
		if inMode:
			burnLevel = 0
		else:
			smokeParticleSystem.emissionRate = 0
			flameSpriteRenderer.sprite = null

	def Update():
		return if not inMode
		updateFlame()
		# DebugScreen.logRow("burn=$(burnLevel.ToString('0.##'))")
	# 	DebugScreen.logRow("in:breath=$(breathDetect.strength)")
	# 	DebugScreen.logRow("in:light=$(lighter.proximity.ToString('0.##'))")
	# 	DebugScreen.logRow("in:burn=$(burnLevel.ToString('0.##'))")

	def FixedUpdate():
		return if not inMode
		updateBurn()
		updateSmoke()

	def updateFlame():
		flameSuction = breathDetect.strength * lighter.proximity
		if lighter.lit:
			# DebugScreen.logRow("suction=$(flameSuction.ToString('0.##'))")
			now = Time.time
			if lastFlickerTime:
				if now - lastFlickerTime < flameFlickerDuration:
					return
				lastFlickerTime = 0
			shoudFlicker = Random.value < flameFlickerChance
			if shoudFlicker:
				lastFlickerTime = now
				choice = Mathf.Lerp(0.1, 1 - 0.1, flameSuction) + Random.Range(-0.1 cast single, 0.1)
			else:
				choice = flameSuction
			flameSpriteRenderer.sprite = Utils.pickSprite(flameSprites, choice)
		else:
			flameSpriteRenderer.sprite = null

	def updateBurn():
		increaseBurn()
		decreaseBurn()

		if offCheckEnabled:
			if burnLevel < offThreshold:
				offCheckEnabled = false
				burnLevel = 0
		else:
			if burnLevel > offThreshold:
				offCheckEnabled = true

	def onBurnLevelChanged():
		burnSpriteRenderer.sprite = Utils.pickSprite(burnSprites, burnLevel)

	def increaseBurn():
		fanPotential = Mathf.Clamp01(burnLevel * 2)
		fanPower = breathDetect.strength * fanPotential * fanFactor
		lighterPower = breathDetect.strength * lighter.proximity * lighterFactor
		heat = fanPower + lighterPower
		# if lighter.proximity:
		# 	Debug.Log("*** fanPower=$(fanPower) lighterPower=$(lighterPower)")
		burnLevel += heat * Time.deltaTime

	def decreaseBurn():
		burnLevel -= chillFactor * burnLevel * Time.deltaTime
		# Debug.Log("*** chillFactor=$(chillFactor) chillFactor * burnLevel=$(chillFactor * burnLevel)")

	def updateSmoke():
		smokeParticleSystem.emissionRate = Mathf.Lerp(smokeEmissionRates[0], smokeEmissionRates[1], burnLevel)
		# Debug.Log("smokeParticleSystem.renderer.material.shader=$(smokeParticleSystem.renderer.material.shader)")
		smokeParticleSystem.startColor.a = Mathf.Lerp(smokeTintAlphas[0], smokeTintAlphas[1], burnLevel)

		particles = array(ParticleSystem.Particle, smokeParticleSystem.particleCount)
		count = smokeParticleSystem.GetParticles(particles)
		# Debug.Log("smokeParticleSystem.particleCount=$(smokeParticleSystem.particleCount) count=$(count)")
		velocity = Mathf.Lerp(smokeVelocities[0], smokeVelocities[1], breathDetect.strength)
		for particle in particles:
			age = 1 - (particle.lifetime / particle.startLifetime)
			particle.velocity.z = age * velocity
			# Debug.Log("*** particle.position.z=$(particle.position.z)")
			# if particle.position.z < 0.1:
			# 	particle.position.y -= 2 * Time.deltaTime
		smokeParticleSystem.SetParticles(particles, count)
