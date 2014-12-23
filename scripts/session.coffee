{TextMessage} = require '../node_modules/hubot/src/message'

module.exports = (robot) ->
  session = null
  robot = robot

  handle_incoming_msg= (text) =>
    user = robot.brain.userForId '100', name: 'Greenbot', room: 'Greenbot'
    robot.send user, text
  
  send_cmd_to_session = (session, cmd ) ->
    session.stdin.write("#{cmd}\n")

  start_session = (cmd, args) ->
    spawn = require("child_process").spawn
    opts = {
       cwd: "/Users/thomashowe/Documents/src/agent_bot"
    }
    session = spawn(cmd, args,opts)
    session.stdout.on "data", (buffer) -> handle_incoming_msg(buffer)
    session.stderr.on "data", (buffer) -> handle_incoming_msg(buffer)
    session.on "exit", (code, signal) ->
      console.log("Session ended with #{code}")
      session = null
    session


  robot.hear /(.*)/i, (msg) =>
    if session
      send_cmd_to_session session, msg.message.text
    else
      msg.match.shift()
      args = msg.match[0].split(" ")
      cmd = args[0]
      args.shift()
      session = start_session(cmd, args)


