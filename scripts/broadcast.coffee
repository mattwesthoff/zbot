# broadcast a message to every room the bot is in
#
# allhands [msg]

module.exports = (robot) ->
  robot.respond /(?:(allhands|broadcast)) (.+)/i, (msg) ->
    msg.reply msg.match[2]