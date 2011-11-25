# grab cases from JIRA when people mention them
#
# "blah blah jcm-1145 "
# jcm-1145: "a case about things and stuff" - https://blah

class JiraHandler
	constuctor: (@msg) ->
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
			@issueList = []
			@issueList.push( {key: "testIssue", summary: "a fake summary"} )
			for issue in results.issues
				@getJSON issue.self, null, (err, details) =>
					if err
						@issueList.push( {key: "error", summary: "couldn't get issue details from JIRA"} )
						return
					@msg.send "directoutput: #{details.key}: #{details.fields.summary.value}"
					unless details.key?
						@msg.send "didn't get details for an issue"
						return
					@issueList.push( {key: details.key, summary: details.fields.summary.value} )
					
			@msg.send "output list length: #{issueList.length}"
			if @issueList.length > 0
				output = (@issueList.map (i) -> "#{i.key}: #{i.summary}").join("\n")
				@msg.send output
			
module.exports = (robot) ->
	robot.hear /\b([A-Za-z]{3,5}-[\d]+)/i, (msg) ->
		msg.send "#{msg.match[1]}"
		handler = new JiraHandler msg
		handler.getIssue msg.match[1]
	
	robot.respond /jira me(?: issues where)? (.+)$/i, (msg) ->
		handler = new JiraHandler msg
		handler.getIssues msg.match[1]