{Adapter, TextMessage} = require 'hubot'

config =
  baseUrl: process.env.HUBOT_CHADVENTAR_BASE_URL ? 'http://localhost:8888'

class Chadventar extends Adapter
  send: (envelope, strings...) ->
    data = JSON.stringify { name: envelope.name, text: strings.join('\n') }
    @robot.http(config.baseUrl + '/messages')
      .header('Content-Type', 'application/json')
      .post(data) (err) =>
        return @robot.logger.error(err) if err?

  run: ->
    @robot.router.post '/chadventar/messages', (req, res) =>
      {name, text} = req.body
      user = @robot.brain.userForId name, room: 'room'
      @receive new TextMessage(user, text, 'messageId')
      res.send 201

    @emit 'connected'

module.exports.use = (robot) ->
  new Chadventar(robot)
