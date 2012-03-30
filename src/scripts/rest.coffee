#!/usr/bin/env coffee

QS = require 'qs'

module.exports = (robot) ->
  robot.route "/someone/said", (req, res) ->
    showForm = () ->
      return """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Say something</title>
    <meta http-equiv="content-type" content="text/html, charset=UTF-8">
    <link rel="stylesheet" href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" />
    <link rel="stylesheet" href="http://twitter.github.com/bootstrap/assets/css/bootstrap-responsive.css" />
    <style>
    </style>
    </head>
    <body>
      <div class="container">
        <div class="hero-unit" style="padding-top: 20px;">
          <h2>Hubot Messager Service</h2>
          <form action="/someone/said">
            <ul class="nav" style="margin-top: 20px;">
              <li>
                <label for="dest">Destination</label>
                <input type="text" id="dest" name="dest" />
              </li>
              <li>
                <label for="msg">Message</label>
                <textarea id="msg" name="msg" style="margin-top: 0px; margin-bottom: 9px; height: 163px; margin-left: 0px; margin-right: 0px; width: 384px; "></textarea>
              </li>
              <li>
                <input type="submit" name="submit" value="Submit" />
              </li>
            </ul>
          </form>
        </div>
      </div>
    </body>
    </html>
    """
    hasQuery = req.url.indexOf("?")
    if hasQuery < 0
      res.end showForm()
      return
    req.query = QS.parse(req.url.substring(hasQuery + 1))
    if not req.query.msg
      res.end showForm()
      return

    msg = req.query.msg
    dest = if req.query.dest then req.query.dest.split(",") else process.env.HUBOT_IRC_ROOMS.split(",")

    for target in dest
      target = target.trim()
      if target.indexOf("#") == 0
        target = { room: target }
      else
        target = { name: target }
      robot.send target, msg

    res.end("Your message '#{msg}' has been sent to #{dest}")
