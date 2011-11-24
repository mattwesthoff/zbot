# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->
	robot.respond /where do you live/i, (msg) ->
		msg.send "I live at https://github.com/mattoraptor/zbot"
	
	robot.hear /([A-Za-z]{3}-\d*)/i, (msg) ->
		msg.send "that looks like a JIRA case, here's ag link: http://zsassociates.onjira.com/browse/#{msg.match[1]}" 