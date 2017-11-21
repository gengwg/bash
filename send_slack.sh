## Send an text alert to a slack channel
# 
# check the output of a command. only if output is not empty, send alert to slack.
# otherwise do not send. output is also formated for better reading.
# 
## Usage:
#
# crontab:
# # send alert to slack channel every hour
# 0 * * * *  /root/gwg/send_slack.sh | slacker -n 'W Geng' -i :turtle: -c comms_alerts
#
## Prerequisites
# 
# pip install slacker-cli
# export SLACK_TOKEN="xoxp-000000000"
#

output=$(/root/gwg/actual_vs_expected_sends_cass.py)
# check the output of a command. only if output is not empty, send alert to slack.
if [ -n "$output" ]; then
  # output is formated for better reading.
  echo '```'
  echo "$output"
  echo '```'
fi
