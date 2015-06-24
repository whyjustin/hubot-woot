# Description:
#   Pull current woots
#
# Commands:
#   hubot woot - Displays the current woot.
#   hubot woot <shirt|electronic|computer|all> - Displays the current woot site.
#   hubot poll - Displays the current woot poll.

wootAPI = process.env.HUBOT_WOOT_API_KEY

baseUrl = 'http://api.woot.com/2/'

stripMarkup = (html) ->
  html.replace /(<\?[a-z]*(\s[^>]*)?\?(>|$)|<!\[[a-z]*\[|\]\]>|<!DOCTYPE[^>]*?(>|$)|<!--[\s\S]*?(-->|$)|<[a-z?!\/]([a-z0-9_:.])*(\s[^>]*)?(>|$))/gi, ''

module.exports = (robot) ->
  getAndSendWootDetails = (res, site) ->
    robot.http("#{baseUrl}events.json?site=#{site}&eventType=Daily&key=#{wootAPI}").get() (err, rs, body) ->
      if err
        res.send "#{err}"
      else
        todaysWoot = JSON.parse(body)[0].Offers[0]
        todaysItem = todaysWoot.Items[0]
        todaysPhoto = todaysWoot.Photos[0]
        res.send """
          *#{todaysWoot.Title}*: $#{todaysItem.SalePrice}
          #{stripMarkup todaysWoot.Teaser}
          #{todaysPhoto.Url}
          """

  getAndSendWootPoll = (res, site) ->
    robot.http("#{baseUrl}polls.json?site=#{site}&key=#{wootAPI}").get() (err, rs, body) ->
      if err
        res.send "#{err}"
      else
        todaysDiscussion = JSON.parse(body)[0].Questions[0]
        questionResponse = "*#{todaysDiscussion.Text}*"
        questionResponse += ("\n#{response.Text}: #{response.VoteCount}" for response in todaysDiscussion.Responses)
        res.send questionResponse

  robot.respond /woot(.*)?/i, (res) ->
    if res.match.length > 1
      site = res.match[1]
      switch site
        when " shirt"
          getAndSendWootDetails res, "shirt.woot.com"
        when " electronic"
          getAndSendWootDetails res, "electronics.woot.com"
        when " computer"
          getAndSendWootDetails res, "computers.woot.com"
        when " all"
          getAndSendWootDetails res, "www.woot.com"
          getAndSendWootDetails res, "shirt.woot.com"
          getAndSendWootDetails res, "electronics.woot.com"
          getAndSendWootDetails res, "computers.woot.com"
        when " poll"
          getAndSendWootPoll res, "www.woot.com"
        else
          getAndSendWootDetails res, "www.woot.com"
    else
      getAndSendWootDetails res, "www.woot.com"