# Engineer Notifier! :dragon_face:

A hack to improve Github-Slack notifications. 

### Problem
When a comment is posted on Github PR, you get a post to your slack channel by Github bot if you installed the integration.
Slack does not notify you when you or someone in your team is mentioned in the comment exlicitly, e.g. '@your_gh_handle CR please?', because the mention comes inside `attachments` attribute of incoming JSON.

### Solution
This bot will repost to channel mentioning the appropriate party and triggering the notification.

### Environment variables

* SLACK_API_TOKEN
  * Bot token issued by Slack

* MENTIONS_TO_HANDLES
  * Hash where keys are mentions and values are slack handles.
  * Note that slack handles need to be formatted for bots
    * Slack user handle example: `@U0EXLJ7RM`
    * Slack subteam handle example: `!subteam^S0DPXCWRD`
    * [See more on slack formatting](https://api.slack.com/docs/formatting)

* CHANNEL_IDS
  * Array of channel ids, obtainable [here](https://api.slack.com/methods/channels.list)

#### Built on top of the awesome [slack-ruby-bot](https://github.com/dblock/slack-ruby-bot)
