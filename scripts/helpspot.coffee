# interact with helpspot
#
# "blah blah hs 58985"
# "# - customer - link"

class HelpspotHandler
	constructor: (@msg) ->
		@username = process.env.HUBOT_HELPSPOT_USER
		@password = process.env.HUBOT_HELPSPOT_PASSWORD
		@auth = "Basic " + new Buffer(@username + ":" + @password).toString('base64')
		
	getIssueJson: (query, callback) ->
		@msg.http("http://app.zsservices.com/helpspot/api/index.php")
			.header('Authorization', @auth)
			#.query(query)
			.get() (err, res, body) ->
				callback(err, JSON.parse(body))
				
	getCaseDetails: (id) ->
		@getIssueJson {method: "private.request.get", output: "json", xRequest: id}, (err, hsCase) ->
			@msg.send "assigned to: #{hsCase.xPersonAssignedTo}, status: #{hsCase.xStatus}"
				
module.exports = (robot) ->
	robot.hear /\b(?:hs|HS|Hs|Hs)[ ]?[-#]?[ ]?([\d]+)/i, (msg) ->
		handler = new HelpspotHandler msg
		handler.getCaseDetails msg.match[1]