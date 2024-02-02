---
title: Test issue bot on {{ date | tz('America/New_York') | date('dddd, MMMM Do, [at] LT') }}
---
This is a test, ignore this issue.

URL: {{ env.REPO_URL }}/actions/runs/{{ env.RUN_ID }}
