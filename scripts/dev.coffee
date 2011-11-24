# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->

  robot.respond /where do you live/i, (msg) ->
    msg.send "I live at https://github.com/mattoraptor/zbot"
    
  robot.hear /^can you hear me/i, (msg) ->
    if (!msg.message) 
      msg.send 'no message!'
    
    msg.send 'cool'
