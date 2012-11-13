# grab cases from JIRA when people mention them
#
# "... jcm-1145 ... "    - Reports details about any case mentioned in the chat
# jira me (jql)   - Runs JQL query against jira and returns the results

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
		url = "http://#{@domain}.atlassian.net/rest/api/latest/issue/#{id.toUpperCase()}"
		@getJSON url, null, (err, issue) =>
			if err
				@msg.send "error trying to access JIRA"
				return
			unless issue.fields?
				@msg.send "Couldn't find the JIRA issue #{id}"
				return
			@msg.send "#{id}: #{issue.fields.summary.value}"
	
	getIssues: (jql) ->
		url = "http://#{@domain}.atlassian.net/rest/api/latest/search"
		@getJSON url, jql, (err, results) =>
			if err
				@msg.send "error trying to access JIRA"
				return
			unless results.issues? and results.total isnt 0
				@msg.send "Couldn't find any issues"
				return
			output = ["query:\t#{jql}"]
			index = 0
			count = results.issues.length
			for issue in results.issues
				@getJSON issue.self, null, (err, details) =>
					index++
					if err
						output.push "#{issue.key}\tcouldn't get issue details from JIRA"
					else
						output.push (@formatIssueSummary details)
					@msg.send output.join("\n") if index is count

	formatIssueSummary: (details) ->
		return "#{details.key}:\t#{details.fields.assignee.value?.displayName}\t#{details.fields.status?.value?.name}\t'#{details.fields.summary?.value}'"
	
module.exports = (robot) ->
	robot.hear /\b([A-Za-z]{3,}-[\d]+)/i, (msg) ->
		handler = new JiraHandler msg
		handler.getIssue msg.match[1]
	
	robot.respond /jira me(?: issues where)? (.+)$/i, (msg) ->
		handler = new JiraHandler msg
		handler.getIssues msg.match[1]