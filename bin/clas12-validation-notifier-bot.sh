#!/bin/bash
# get the status of the most recent, scheduled `clas12-validation` workflow run
# - returns exit code 100 if the job failed, and generates an email message 'message.txt'
# - this should be used in a cronjob for a notification service

set -e

### functions
warn()  { echo "WARNING: $@" >&2; }
error() { echo "ERROR: $@" >&2; }
dump()  { echo "$@" | jq; }

### constants
repo=JeffersonLab/clas12-validation
message_file=message.txt

### choose the day (may need to get yesterday's results, if we crossed midnight)
which_day=today
case $which_day in
  today)     day=$(date +%Y-%m-%d) ;;
  yesterday) day=$(date +%Y-%m-%d -d 'yesterday 08:00') ;;
  *)
    error "Unknown 'which_day' variable '$which_day'"
    exit 1
esac

### get the list of workflow runs
echo "Query $repo for scheduled workflows from $day ..."
payload_run_list=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$repo/actions/runs?event=schedule&created=>=$day"
)
# dump $payload_run_list

### there should be only 1 such run; get its results
num_runs=$(echo $payload_run_list | jq -r '.total_count')
[ $num_runs -eq 0 ] && error "no workflow runs returned" && exit 1
[ $num_runs -gt 1 ] && warn "$num_runs workflow runs found for today, which is more than one; assuming the first is the most recent"
payload_run=$(echo $payload_run_list | jq -r '.workflow_runs[0]')
payload_result=$(echo $payload_run | jq '{ conclusion: .conclusion, url: .html_url, time: .run_started_at }')
conclusion=$(echo $payload_result | jq -r '.conclusion')
echo "Today's workflow result: $conclusion"

### generate an email message, if the job failed
if [ "$conclusion" = "failure" ]; then
  cat << EOF > $message_file
Dear all,

The scheduled clas12-validation CI workflow run from $which_day has failed! See the following link for details:

$(echo $payload_result | jq -r '.url')

The run was started at $(echo $payload_result | jq -r '.time').

Best regards,
- The clas12-validation CI Notifier Bot
EOF
  echo "Wrote email message to $message_file"
  exit 100
fi
