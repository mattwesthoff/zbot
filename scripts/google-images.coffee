# A way to interact with the Google Images API.
#
# image me <query>    - The Original. Queries Google Images for <query> and
#                       returns a the top result.
# random image me <query>  - Same as `image me`, except returns a random 
                              result
# animate me <query>  - The same thing as `image me`, except adds a few
#                       parameters to try to return an animated GIF instead.
# mustache me <url>   - Adds a mustache to the specified URL.
# mustache me <query> - Searches Google Images for the specified query and
#                       mustaches it.
module.exports = (robot) ->

  robot.respond /random (image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], true, (url) ->
      msg.send url

  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], false, (url) ->
      msg.send url

  robot.respond /animate me (.*)/i, (msg) ->
    imageMe msg, "animated #{msg.match[1]}", false, (url) ->
      msg.send url

  robot.respond /(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify}#{imagery}"
    else
      imageMe msg, imagery, true, (url) ->
        msg.send "#{mustachify}#{url}"

mustachify = "http://mustachify.me/?src="

imageMe = (msg, query, random, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(v: "1.0", rsz: '8', q: query, safe: "active")
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      if (random)
        image  = msg.random images
      else
        image = images[0]
      cb "#{image.unescapedUrl}#.png"

