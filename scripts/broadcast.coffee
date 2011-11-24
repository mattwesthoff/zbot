# broadcast a message to every room the bot is in
#
# allhands [msg]

module.exports = (robot) ->
  robot.respond /(?:(allhands|broadcast)) (.+)/i, (msg) ->
    currentRoom = msg.message.user.room
    braodcast = "#{msg.message.user.name}:#{msg.match[2]}\n\tfrom room:https://zssd.campfirenow.com/room/#{currentRoom}"
    for roomId in process.env.HUBOT_CAMPFIRE_ROOMS.split(",")
      do (roomId) ->
        msg.message.user.room = roomId
        msg.send "broadcast is: #{broadcast}" unless roomId is currentRoom