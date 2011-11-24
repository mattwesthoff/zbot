# grab cases from JIRA when people mention them
#
# "blah blah jcm-1145 "
# jcm-1145: "a case about things and stuff" - https://blah

module.exports = (robot) ->
	robot.hear /([A-Za-z]{3}-\d*)/i, (msg) ->
		msg.send "that looks like a JIRA case, here's a link: http://zsassociates.onjira.com/browse/#{msg.match[1]}" 
		username = process.env.HUBOT_JIRA_USER
		password = process.env.HUBOT_JIRA_PASSWORD
		domain = process.env.HUBOT_JIRA_DOMAIN
		
		error = "%s is not configured in your environment"
		unless username
			msg.send (error % "HUBOT_JIRA_USER")
			return
		unless password
			msg.send (error % "HUBOT_JIRA_PASSWORD")
			return
		unless domain
			msg.send (error % "HUBOT_JIRA_DOMAIN")
			return
		
		url = "https://#{domain}.jira.com/rest/api/latest/search"
		