config =
  mailchimp:
    action: '//digitalcoachingnetwork.us11.list-manage.com/subscribe/post?u=68d703ae770920ff4a8b715e2&amp;id=a3577a5ba4'
  mongo:
    connectionString: process.env.MONGOLAB_URI || 'localhost/dcn'

module.exports = config
