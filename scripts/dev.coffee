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
		output = "http://www.qwantz.com/index.php?butiwouldratherbereading=alessonislearnedbutthedamageisirreversible\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=aboutpirates\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=achewood\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=buttercupfestival\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=daisyowl\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=dccomics\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=justabouttrex\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=nedroid\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=onedoneinwatercolours\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=onewheretrexgotassimilated\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=onewheretrexswearsmore\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=onewheretrexwearsmore\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=pennyarcade\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=pokey\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=problemsleuth\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=registeredweapon\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=shortpacked\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=sisterclaire\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=somethingmorehistoricallyaccurate\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=sweetbroandhellajeff\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=thelastdinosaurcomicever\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=wigu\n" + 
			"http://www.qwantz.com/index.php?butiwouldratherbereading=wondermark\n" +
			"http://www.qwantz.com/index.php?butiwouldratherbereading=xkcd"
		msg.send output
