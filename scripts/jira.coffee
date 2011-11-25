# grab cases from JIRA when people mention them
#
# "blah blah jcm-1145 "
# jcm-1145: "a case about things and stuff" - https://blah

module.exports = (robot) ->
	robot.hear /([A-Za-z]{3}-\d*)/i, (msg) ->
		username = process.env.HUBOT_JIRA_USER
		password = process.env.HUBOT_JIRA_PASSWORD
		domain = process.env.HUBOT_JIRA_DOMAIN
		url = "http://#{domain}.onjira.com/rest/api/latest/issue/#{msg.match[1]}"
		auth = "Basic " + new Buffer(username + ":" + password).toString('base64')
		getJSON msg, url, "", auth, (err, json) ->
			if err
				msg.send "error trying to access JIRA"
				return
			if json.total? and (parseInt(json.total) is 0)
				msg.send "Couldn't find the JIRA issue"
				return
			msg.send "Found the JIRA issue"
		
		msg.send "that looks like a JIRA case, here's a link: http://zsassociates.onjira.com/browse/#{msg.match[1]}" 
		
getJSON = (msg, url, query, auth, callback) ->
	msg.http(url)
		.header('Authorization', auth)
		.query(jql: query)
		.get() (err, res, body) ->
			callback(err, JSON.parse(body))