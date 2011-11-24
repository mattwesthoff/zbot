# broadcast a message to every room the bot is in
#
# allhands [msg]

module.exports = (robot) ->
	robot.respond /(?:(allhands|broadcast)) (.+)/i, (msg) ->
		currentRoom = msg.message.user.room
		sender = msg.message.user.name
		for roomId in process.env.HUBOT_CAMPFIRE_ROOMS.split(",")
			do (roomId) ->
				isCurrentRoom = parseInt(roomId) is parseInt(currentRoom)
				broadcast = "[#{sender}] #{msg.match[2]} (reply in https://zssd.campfirenow.com/room/#{currentRoom})"
				msg.reply "sent your all hands message" if isCurrentRoom
				msg.message.user.room = roomId
				msg.send broadcast unless isCurrentRoom