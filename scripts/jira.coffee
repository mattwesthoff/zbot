# grab cases from JIRA when people mention them
#
# "blah blah jcm-1145 "
# jcm-1145: "a case about things and stuff" - https://blah

module.exports = (robot) ->
	robot.hear /([A-Za-z]{3}-\d*)/i, (msg) ->
		
		missing_config_error = "%s setting missing from env config!"
		unless process.env.HUBOT_JIRA_USER?
			msg.send (missing_config_error % "HUBOT_JIRA_USER")
		unless process.env.HUBOT_JIRA_PASSWORD?
			msg.send (missing_config_error % "HUBOT_JIRA_PASSWORD")
		unless process.env.HUBOT_JIRA_DOMAIN?
			msg.send (missing_config_error % "HUBOT_JIRA_DOMAIN")
		
		username = process.env.HUBOT_JIRA_USER
		password = process.env.HUBOT_JIRA_PASSWORD
		domain = process.env.HUBOT_JIRA_DOMAIN
		
		url = "http://#{domain}.onjira.com/rest/api/latest/issue/#{(msg.match[1]).toUpperCase()}"
		auth = "Basic " + new Buffer(username + ":" + password).toString('base64')
		
		getJSON msg, url, "", auth, (err, issue) ->
			if err
				msg.send "error trying to access JIRA"
				return
			unless issue.fields?
				msg.send "Couldn't find the JIRA issue"
				return
			msg.send "#{msg.match[1]}: #{issue.fields.summary.value}"
	
	robot.respond /jira me(?: issues where)? (.+)/i, (msg) ->
		username = process.env.HUBOT_JIRA_USER
		password = process.env.HUBOT_JIRA_PASSWORD
		domain = process.env.HUBOT_JIRA_DOMAIN
		url = "http://#{domain}.onjira.com/rest/api/latest/search"
		auth = "Basic " + new Buffer(username + ":" + password).toString('base64')
		queryString = "jql=#{msg.match[1]}"
		msg.send "#{url}?#{queryString}"
		getJSON msg, url, queryString, auth, (err, results) ->
			if err
				msg.send "error trying to access JIRA"
				return
			unless results?
				msg.send "Couldn't find any issues"
				return
			msg.send "Found #{results.total} issues that matched your query:"
			issueList = []
			for issue in results.issues
				msg.send issue.self
				getJSON msg, issue.self, "", auth, (err, details) ->
					if err
						msg.send "error getting issue details from JIRA"
						return
					issueList.push( {key: details.key, summary: details.fields.summary.value} )
			if issueList? and issueList.length isnt 0
				output = (issueList.map (i) -> "#{i.key}: #{i.summary}").join("\n")
				msg.send output
				
			
getJSON = (msg, url, query, auth, callback) ->
	msg.http(url)
		.header('Authorization', auth)
		.query(jql: query)
		.get() (err, res, body) ->
			callback(err, JSON.parse(body))