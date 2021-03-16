# $1: firewall user account (ansible)
# $2: firwall hostname
# $3: command
# $4: <null>|configure
ssh  -o "StrictHostKeyChecking=no" -tt $1@$2 << EOF
  set cli pager off
  set cli config-output-format set
  set cli terminal width 500
  $4
  $3
  quit
  quit
EOF
