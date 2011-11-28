# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->
	
	console.log robot.brain
	
	robot.respond /where do you live/i, (msg) ->
		msg.send "I live at https://github.com/mattoraptor/zbot"