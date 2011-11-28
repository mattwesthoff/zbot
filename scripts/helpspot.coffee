# interact with helpspot
#
# "blah blah hs 58985"
# "# - customer - link"

class HelpspotHandler
	constructor: (@msg) ->
		@username = process.env.HUBOT_HELPSPOT_USER
		@password = process.env.HUBOT_HELPSPOT_PASSWORD
		@auth = "Basic " + new Buffer(@username + ":" + @password).toString('base64')
	
	getCaseDetails: (id) ->
		url = "http://app.zsservices.com/helpspot/api/index.php"
		callback = (err, body) ->
			@msg.send "assigned to: #{body.xPersonAssignedTo}, status: #{body.xStatus}"
		@msg.http(url)
			.header('Authorization', @auth)
			.query(method: 'private.request.get')
			.query(output: "json")
			.query(xRequest: id)
			.get() (err, res, body) ->
				callback(err, JSON.parse(body))
				
module.exports = (robot) ->
	robot.hear /\b(?:hs|HS|Hs|Hs)[ ]?[-#]?[ ]?([\d]+)/i, (msg) ->
		handler = new HelpspotHandler msg
		handler.getCaseDetails msg.match[1]
		