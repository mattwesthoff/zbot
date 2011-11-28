# interact with helpspot
#
# "blah blah hs 58985"
# "# - customer - link"

class HelpspotHandler
	constructor: (@msg) ->
		missing_config_error = "%s setting missing from env config!"
		unless process.env.HUBOT_HELPSPOT_USER?
			@msg.send (missing_config_error % "HUBOT_HELPSPOT_USER")
		unless process.env.HUBOT_HELPSPOT_PASSWORD?
			@msg.send (missing_config_error % "HUBOT_HELPSPOT_PASSWORD")
			
		@username = process.env.HUBOT_HELPSPOT_USER
		@password = process.env.HUBOT_HELPSPOT_PASSWORD
		@auth = "Basic " + new Buffer(@username + ":" + @password).toString('base64')
		
	getIssueJson: (caseNum, callback) ->
		@msg.http("http://app.zsservices.com/helpspot/api/index.php")
			.header('Authorization', @auth)
			.query("method", "private.request.get")
			.query("output", "json")
			.query("xRequest", caseNum)
			.get() (err, res, body) ->
				callback(err, JSON.parse(body))
				
	getCaseDetails: (caseNum) ->
		@getIssueJson caseNum, (err, hsCase) =>
			console.log " got to the callback "
			@msg.send "assigned to: #{hsCase.xPersonAssignedTo}, status: #{hsCase.xStatus}"
				
module.exports = (robot) ->
	robot.hear /\b(?:hs|HS|Hs|Hs)[ ]?[-#]?[ ]?([\d]+)/i, (msg) ->
		handler = new HelpspotHandler msg
		handler.getCaseDetails msg.match[1]