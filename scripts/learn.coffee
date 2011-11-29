#use duckduckgo api to define words or phrases
#
# learn me <term>    - Queries DuckDuckGo's api to define the term

module.exports = (robot) ->
	robot.respond /learn me(?: a)? (.+)$/i, (res) ->
		abstract_url = "http://api.duckduckgo.com/?format=json&q=#{encodeURIComponent(res.match[2])}"
		console.log "I should query ddg for #{encodeURIComponent(res.match[2])}"