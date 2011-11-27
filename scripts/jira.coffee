# grab cases from JIRA when people mention them
#
# "blah blah jcm-1145 "
# jcm-1145: "a case about things and stuff" - https://blah

class JiraHandler
	
	constructor: (@msg) ->
		missing_config_error = "%s setting missing from env config!"
		unless process.env.HUBOT_JIRA_USER?
			@msg.send (missing_config_error % "HUBOT_JIRA_USER")
		unless process.env.HUBOT_JIRA_PASSWORD?
			@msg.send (missing_config_error % "HUBOT_JIRA_PASSWORD")
		unless process.env.HUBOT_JIRA_DOMAIN?
			@msg.send (missing_config_error % "HUBOT_JIRA_DOMAIN")
			
		@username = process.env.HUBOT_JIRA_USER
		@password = process.env.HUBOT_JIRA_PASSWORD
		@domain = process.env.HUBOT_JIRA_DOMAIN
		@auth = "Basic " + new Buffer(@username + ":" + @password).toString('base64')
		
	getJSON: (url, query, callback) ->
		@msg.http(url)
			.header('Authorization', @auth)
			.query(jql: query)
			.get() (err, res, body) ->
				callback(err, JSON.parse(body))
	
	getIssue: (id) ->
		url = "http://#{@domain}.onjira.com/rest/api/latest/issue/#{id.toUpperCase()}"
		@getJSON url, null, (err, issue) =>
			if err
				@msg.send "error trying to access JIRA"
				return
			unless issue.fields?
				@msg.send "Couldn't find the JIRA issue #{id}"
				return
			@msg.send "#{id}: #{issue.fields.summary.value}"
	
	getIssues: (jql) ->
		url = "http://#{@domain}.onjira.com/rest/api/latest/search"
		@getJSON url, jql, (err, results) =>
			if err
				@msg.send "error trying to access JIRA"
				return
			unless results.issues?
				@msg.send "Couldn't find any issues"
				return
			issueList = []
			count = results.issues.length
			index = 0
			for issue in results.issues
				@getJSON issue.self, null, (err, details) =>
					index++
					if err
						issueList.push {key: issue.key, summary: "couldn't get issue details from JIRA"}
					else
						issueList.push {key: details.key, summary: details.fields.summary.value}
					@msg.send ((issueList.map (i) -> "#{i.key}: #{i.summary}").join("\n")) if index is count
			
module.exports = (robot) ->
	robot.hear /\b([A-Za-z]{3,5}-[\d]+)/i, (msg) ->
		handler = new JiraHandler msg
		handler.getIssue msg.match[1]
	
	robot.respond /jira me(?: issues where)? (.+)$/i, (msg) ->
		handler = new JiraHandler msg
		handler.getIssues msg.match[1]