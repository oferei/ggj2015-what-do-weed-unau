# import UnityEngine

class MessageSmokeMode(Message):

	enabled:
		get:
			return _enabled
	_enabled as bool
 
	def constructor(enabled):
 
		_enabled = enabled
 
		# send the message
		super()
