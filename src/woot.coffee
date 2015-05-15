# Description:
#   Pull current woots
#
# Commands:
#   hubot woot - Displays the current woot.

wootAPI = process.env.HUBOT_WOOT_API_KEY

baseUrl = 'http://api.woot.com/2/'

todaysWootUrl = baseUrl + 'events.json?site=www.woot.com&eventType=Daily&key=' + wootAPI

module.exports = (robot) ->
  robot.respond /woot/i, (msg) ->
    robot.http(todaysWootUrl).get() (err, res, body) ->
      if error?
        msg.send "#{body}"
      else
        todaysWoot = JSON.parse(body)[0].Offers[0]
        todaysItem = todaysWoot.Items[0]
        todaysPhoto = todaysWoot.Photos[0]
        msg.send """
          #{todaysWoot.Title}: $#{todaysItem.SalePrice}\n#{todaysPhoto.Url}
          """
