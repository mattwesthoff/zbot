
  module.exports = function(robot) {
    return robot.respond(/(?:(allhands|broadcast)) (.+)/i, function(msg) {
      var braodcast, currentRoom, roomId, _i, _len, _ref, _results;
      currentRoom = msg.message.user.room;
      braodcast = "" + msg.message.user.name + ":" + msg.match[2];
      _ref = process.env.HUBOT_CAMPFIRE_ROOMS.split(",");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        roomId = _ref[_i];
        _results.push((function(roomId) {
          msg.message.user.room = roomId;
          if (roomId !== currentRoom) {
            return msg.send("broadcast is: " + broadcast);
          }
        })(roomId));
      }
      return _results;
    });
  };
