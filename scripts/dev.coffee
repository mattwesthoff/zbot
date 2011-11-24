# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->

  robot.respond /where do you live/i, (msg) ->
    msg.send "I live at https://github.com/mattoraptor/zbot"
    
  robot.hear /^can you hear me/i, (msg) ->
    msg.send "the user is #{msg.message.user.name} in #{msg.message.user.room}" 
    for roomId in process.env.HUBOT_CAMPFIRE_ROOMS.split(",")
      do (roomId) ->
        newuser = msg.message.user
        newuser.room = roomId
        msg.robot.adapter.send newuser "I hear #{msg.message.user.name}"
