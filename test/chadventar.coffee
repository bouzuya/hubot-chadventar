{expect} = require('chai').use(require('sinon-chai'))
{Robot, User} = require 'hubot'
bodyParser = require 'body-parser'
chadventar = require '../'
express = require 'express'
http = require 'http'
path = require 'path'
request = require 'supertest'
sinon = require 'sinon'

describe 'chadventer', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null

    # start HTTP server (localhost:8888)
    @app = express()
    @app.use bodyParser.json()
    @server = http.createServer(@app)
    @server.listen 8888, =>
      @robot = new Robot(path.resolve(__dirname, '.'), 'shell', true, 'hubot')
      @robot.adapter.on 'connected', =>
        @robot.load path.resolve(__dirname, '../../src/scripts')
        done()
      @robot.run()

  afterEach (done) ->
    # stop server
    @server.close =>
      @robot.brain.on 'close', =>
        close = =>
          @sinon.restore()
          done()
        # NOTE: robot.shutdown() does not close the `robot.server`.
        if @robot.server._handle?
          @robot.server.close close
        else
          close()
      @robot.shutdown()

  describe '#receive', ->
    beforeEach ->
      @robot.adapter.receive = @receive = @sinon.spy()

    it 'works', (done) ->
      request(@robot.server)
        .post '/chadventar/messages'
        .send name: 'bouzuya', text: 'hello'
        .expect 201
        .end (err, res) =>
          expect(@receive).to.have.been.called
          message = @receive.firstCall.args[0]
          expect(message).to.have.property('id', 'messageId')
          expect(message).to.have.property('text', 'hello')
          expect(message).to.have.deep.property('user.id', 'bouzuya')
          expect(message).to.have.deep.property('user.name', 'bouzuya')
          expect(message).to.have.deep.property('user.room', 'room')
          expect(message).to.have.property('room', 'room')
          done(err)

  describe '#send', ->
    it 'works', (done) ->
      name = 'bouzuya'
      text = 'hoge'
      @app.post '/messages', (req, res) ->
        expect(req.body).to.have.deep.equal({ name, text })
        res.sendStatus 201
        done()
      @robot.send new User(name, room: 'room'), text
