# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->

  robot.respond /where do you live/i, (msg) ->
    msg.send "I live at https://github.com/mattoraptor/zbot"
    
  robot.hear /^can you hear me/i, (msg) ->
    msg.send 'there is a user!' if msg.message?.user?
    usermsg = "the user is #{msg.message.user.name} in #{msg.message.user.room}"
    msg.send usermsg
    msg.send 'cool'
