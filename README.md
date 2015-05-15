# hubot-woot

This is a [Hubot](http://hubot.github.com/) script which fetches the latest woot information.

## Getting Started

### Installation

In hubot project repo, run:

`npm install hubot-woot --save`

Then add **hubot-woot** to your `external-scripts.json`:

```json
["hubot-woot"]
```

### Configuration

A woot api key is required to use this script. Fetch one from the [Woot Applications Page](https://account.woot.com/applications). Once acquired, an environmental variable `HUBOT_WOOT_API_KEY` must be set with your application key. For Heroku deployments, this can be acheived by:

`% heroku config:add HUBOT_WOOT_API_KEY=xxxxxxxxxxxx`