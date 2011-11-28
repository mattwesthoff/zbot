# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->
	
	data = robot.brain.data
	data.timelogs = []
	
	robot.respond /where do you live/i, (msg) ->
		msg.send "I live at https://github.com/mattoraptor/zbot"
		
	robot.respond /record time/i, (msg) ->
		data.timelogs.push (new Date()).getTime()
		
	robot.respond /list times/i, (msg) ->
		msg.send timelogs