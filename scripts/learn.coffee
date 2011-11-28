#use duckduckgo api to define words or phrases
#
# learn me <term>    - Queries DuckDuckGo's api to define the term

module.exports = (robot) ->
  robot.respond /learn me(?: a)? (.+)$/i, (res) ->
    abstract_url = "http://api.duckduckgo.com/?format=json&q=#{encodeURIComponent(res.match[2])}"
    res.http(abstract_url)
      .header('User-Agent', 'Hubot Abstract Script')
      .get() (err, _, body) ->
        res.send "Couldn't access ddg api." if err
        data = JSON.parse(body.toString("utf8"))
        return unless data
        topic = data.RelatedTopics[0] if data.RelatedTopics and data.RelatedTopics.length
        if data.AbstractText
          res.send data.AbstractText
          res.send data.AbstractURL if data.AbstractURL
        else if topic and not /\/c\//.test(topic.FirstURL)
          res.send topic.Text
          res.send topic.FirstURL
        else if data.Definition
          res.send data.Definition
          res.send data.DefinitionURL if data.DefinitionURL
        else
          res.send "I don't know what that is, I'm guessing you made it up."