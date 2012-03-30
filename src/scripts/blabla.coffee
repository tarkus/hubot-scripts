# Become a monologist robot 
#
# quiet - quiet mode
# blabla - blabla mode

cycle = 5000
lastActivity = 0
boringTimeout = 5000
boringInhibit = false

randomInt = (range) ->
  return Math.floor(Math.random() * parseInt(range))

randomItem = (list) ->
  return list[randomInt(list.length - 1)]

class Blabla

  constructor: (@robot) ->
    @cycle = 5000
    @lastActivity = new Date().getTime()
    @topics = []
    @inhibit = false

  talkAbout: (name, msg, timesup) ->
    @topics.push {
      msg: msg,
      timesup: timesup
    }
    
  talk: ->
    @now = new Date()
    @timer = setTimeout ( => @talk() ), @cycle
    if not @inhibit and @now.getDay() in [1..5]
      @robot.send { name: 'tarkus' }, randomItem t.msg for t in @topics when t.timesup @now
    @lastActivity = @now.getTime()
    console.log @inhibit

module.exports = (robot) ->
  blabla = new Blabla robot

  blabla.talkAbout "lunch", [
    "lunch time",
    "吃饭了!"
  ], (now) ->
    return now.getHours() == 11 \
      and 55 <= (now.getMinutes() + randomInt(4)) <= 59

  blabla.talkAbout "boring", [
    "I'm boring",
    "I'm hungry"
  ], (now) ->
    return (now.getTime() - blabla.lastActivity) > 5000

  robot.respond /(be )?quiet/i, (msg) ->
    blabla.inhibit = true
    msg.send "ok, I will be quiet, for a while."
    clearTimeout blabla.timer

  robot.respond /blabla/i, (msg) ->
    blabla.inhibit = false
    msg.send "ok, you got it, it's good for you ..."
    blabla.talk()

  robot.hear /.*/, (msg) ->
    blabla.talk()
