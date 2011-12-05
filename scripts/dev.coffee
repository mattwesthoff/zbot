# Explains how to dev this guy
#
# how do I modify you?

module.exports = (robot) ->
	
	data = robot.brain.data
	data.timelogs = []
	
	robot.respond /where do you live/i, (msg) ->
		msg.send "I live at git@github.com:ZS/zbot.git"
		
	robot.respond /record time/i, (msg) ->
		data.timelogs.push (new Date()).getTime()
		
	robot.respond /list times/i, (msg) ->
		msg.send data.timelogs

	robot.respond /qwantz me my options/i, (msg) ->
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=alessonislearnedbutthedamageisirreversible" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=aboutpirates"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=achewood" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=buttercupfestival"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=daisyowl"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=dccomics"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=justabouttrex" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=nedroid" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=onedoneinwatercolours" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=onewheretrexgotassimilated" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=onewheretrexswearsmore" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=onewheretrexwearsmore" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=pennyarcade"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=pokey" 
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=problemsleuth"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=registeredweapon"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=shortpacked"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=sisterclaire"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=somethingmorehistoricallyaccurate"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=sweetbroandhellajeff"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=thelastdinosaurcomicever"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=wigu"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=wondermark"
		msg.send "http://www.qwantz.com/index.php?butiwouldratherbereading=xkcd"
