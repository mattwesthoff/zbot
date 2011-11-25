(function() {
  var JiraHandler;

  JiraHandler = (function() {

    function JiraHandler(msg) {
      var missing_config_error;
      this.msg = msg;
      missing_config_error = "%s setting missing from env config!";
      if (process.env.HUBOT_JIRA_USER == null) {
        this.msg.send(missing_config_error % "HUBOT_JIRA_USER");
      }
      if (process.env.HUBOT_JIRA_PASSWORD == null) {
        this.msg.send(missing_config_error % "HUBOT_JIRA_PASSWORD");
      }
      if (process.env.HUBOT_JIRA_DOMAIN == null) {
        this.msg.send(missing_config_error % "HUBOT_JIRA_DOMAIN");
      }
      this.username = process.env.HUBOT_JIRA_USER;
      this.password = process.env.HUBOT_JIRA_PASSWORD;
      this.domain = process.env.HUBOT_JIRA_DOMAIN;
      this.auth = "Basic " + new Buffer(this.username + ":" + this.password).toString('base64');
    }

    JiraHandler.prototype.getJSON = function(url, query, callback) {
      return this.msg.http(url).header('Authorization', this.auth).query({
        jql: query
      }).get()(function(err, res, body) {
        return callback(err, JSON.parse(body));
      });
    };

    JiraHandler.prototype.getIssue = function(id) {
      var url;
      var _this = this;
      url = "http://" + this.domain + ".onjira.com/rest/api/latest/issue/" + (id.toUpperCase());
      return this.getJSON(url, null, function(err, issue) {
        if (err) {
          _this.msg.send("error trying to access JIRA");
          return;
        }
        if (issue.fields == null) {
          _this.msg.send("Couldn't find the JIRA issue " + id);
          return;
        }
        return _this.msg.send("" + id + ": " + issue.fields.summary.value);
      });
    };

    JiraHandler.prototype.getIssues = function(jql) {
      var output, url;
      url = "http://" + this.domain + ".onjira.com/rest/api/latest/search";
      this.issueList = [];
      this.issueList.push({
        key: "testIssueOut",
        summary: "a fake summary out"
      });
      this.getJSON(url, jql, function(err, results) {
        var issue, _i, _len, _ref, _results;
        if (err) {
          this.msg.send("error trying to access JIRA");
          return;
        }
        if (results.issues == null) {
          this.msg.send("Couldn't find any issues");
          return;
        }
        this.issueList.push({
          key: "testIssue",
          summary: "a fake summary"
        });
        _ref = results.issues;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          issue = _ref[_i];
          _results.push(this.getJSON(issue.self, null, function(err, details) {
            if (err) {
              this.issueList.push({
                key: "error",
                summary: "couldn't get issue details from JIRA"
              });
              return;
            }
            if (details.key == null) {
              this.msg.send("didn't get details for an issue");
              return;
            }
            return this.issueList.push({
              key: details.key,
              summary: details.fields.summary.value
            });
          }));
        }
        return _results;
      });
      if (this.issueList.length > 0) {
        output = (this.issueList.map(function(i) {
          return "" + i.key + ": " + i.summary;
        })).join("\n");
        return this.msg.send(output);
      }
    };

    return JiraHandler;

  })();

  module.exports = function(robot) {
    robot.hear(/\b([A-Za-z]{3,5}-[\d]+)/i, function(msg) {
      var handler;
      handler = new JiraHandler(msg);
      return handler.getIssue(msg.match[1]);
    });
    return robot.respond(/jira me(?: issues where)? (.+)$/i, function(msg) {
      var handler;
      handler = new JiraHandler(msg);
      return handler.getIssues(msg.match[1]);
    });
  };

}).call(this);
