# Engineer Notifier! :dragon_face:

A hack to improve Github-Slack notifications. 

### Problem
When a comment is posted on Github PR, you get a post to your slack channel by Github bot if you installed the integration.
Slack does not notify you when you or someone in your team is mentioned in the comment exlicitly, e.g. '@your_gh_handle CR please?', because the mention comes inside `attachments` attribute of incoming JSON.

### Solution
This bot will repost the mention triggering the notification.

Environment variables are:

* SLACK_API_TOKEN
  * Bot token issued by Slack

* MENTIONS
  * Array of mentions that trigger the bot

* CHANNEL_IDS
  * Array of channel ids

### Credits

[slack-ruby-bot](https://github.com/dblock/slack-ruby-bot)

### License

MIT

