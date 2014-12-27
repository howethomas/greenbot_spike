{TextMessage} = require '../node_modules/hubot/src/message'

module.exports = (robot) ->
  INBOUND_MESSAGES = process.env.HUBOT_INBOUND_REDIS_LIST or "inbound_messages" 
  OUTBOUND_MESSAGES = process.env.HUBOT_OUTBOUND_REDIS_LIST or "outbound_messages" 

  redis = require "redis"
  client = redis.createClient()
  console.log("Created client #{client.toString()}")
  robot.hear /(.*)/i, (msg) =>
    console.log "Sending #{msg.message.text} to REDIS channel #{OUTBOUND_MESSAGES}"
    client.lpush(OUTBOUND_MESSAGES, msg.message.text, redis.print)
    console.log "Sending #{msg.message.text} to REDIS channel #{OUTBOUND_MESSAGES}"

  wait_inbound_redis_message = (key) -> 
    client.blpop key, 0, 
      (err, data) -> 
        console.log "Just received a #{data} from #{INBOUND_MESSAGES}"
        user = robot.brain.userForId '100', name: 'Greenbot', room: 'Greenbot'
        robot.send user, data
        wait_inbound_redis_message key
  
  wait_inbound_redis_message INBOUND_MESSAGES


  
