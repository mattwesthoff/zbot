# broadcast a message to every room the bot is in
#
# allhands [msg]

module.exports = (robot) ->
  robot.respond /(?:(allhands|broadcast)) (.+)/i, (msg) ->
    currentRoom = msg.message.user.room
    for roomId in process.env.HUBOT_CAMPFIRE_ROOMS.split(",")
      do (roomId) ->
        msg.message.user.room = roomId
        msg.send msg.match[2]
		msg.send "#{msg.match[2]}\n\t(#{msg.message.user.name} from room: #{msg.message.user.room})"
