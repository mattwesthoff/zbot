(function() {
  var getJSON;

  module.exports = function(robot) {
    robot.hear(/([A-Za-z]{3}-\d*)/i, function(msg) {
      var auth, domain, missing_config_error, password, url, username;
      missing_config_error = "%s setting missing from env config!";
      if (process.env.HUBOT_JIRA_USER == null) {
        msg.send(missing_config_error % "HUBOT_JIRA_USER");
      }
      if (process.env.HUBOT_JIRA_PASSWORD == null) {
        msg.send(missing_config_error % "HUBOT_JIRA_PASSWORD");
      }
      if (process.env.HUBOT_JIRA_DOMAIN == null) {
        msg.send(missing_config_error % "HUBOT_JIRA_DOMAIN");
      }
      username = process.env.HUBOT_JIRA_USER;
      password = process.env.HUBOT_JIRA_PASSWORD;
      domain = process.env.HUBOT_JIRA_DOMAIN;
      url = "http://" + domain + ".onjira.com/rest/api/latest/issue/" + (msg.match[1].toUpperCase());
      auth = "Basic " + new Buffer(username + ":" + password).toString('base64');
      return getJSON(msg, url, "", auth, function(err, issue) {
        if (err) {
          msg.send("error trying to access JIRA");
          return;
        }
        if ((issue.total != null) && (parseInt(issue.total) === 0)) {
          msg.send("Couldn't find the JIRA issue");
          return;
        }
        return msg.send("" + msg.match[1] + ": " + issue.fields.summary.value);
      });
    });
    return robot.respond(/jira me(?: issues where)? (.+)/i, function(msg) {
      var auth, domain, password, queryString, url, username;
      username = process.env.HUBOT_JIRA_USER;
      password = process.env.HUBOT_JIRA_PASSWORD;
      domain = process.env.HUBOT_JIRA_DOMAIN;
      url = "http://" + domain + ".onjira.com/rest/api/latest/search";
      auth = "Basic " + new Buffer(username + ":" + password).toString('base64');
      queryString = "jql=" + msg.match[1];
      return getJSON(msg, url, queryString, auth, function(err, results) {
        var issue, issueList, output, _i, _len, _ref;
        if (err) {
          msg.send("error trying to access JIRA");
          return;
        }
        if ((results.total != null) && (parseInt(results.total) === 0)) {
          msg.send("Couldn't find any issues");
          return;
        }
        msg.send("Found " + results.total + " issues that matched your query:");
        issueList = [];
        _ref = results.issues;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          issue = _ref[_i];
          getJSON(msg, issue.self, "", auth, function(err, details) {
            if (err) {
              msg.send("error getting issue details from JIRA");
              return;
            }
            return issueList.push({
              key: details.key,
              summary: details.fields.summary.value
            });
          });
        }
        if ((issueList != null) && issueList.length !== 0) {
          output = (issueList.map(function(i) {
            return "" + i.key + ": " + i.summary;
          })).join("\n");
          return msg.send(output);
        }
      });
    });
  };

  getJSON = function(msg, url, query, auth, callback) {
    return msg.http(url).header('Authorization', auth).query({
      jql: query
    }).get()(function(err, res, body) {
      return callback(err, JSON.parse(body));
    });
  };

}).call(this);
