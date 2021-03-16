#!/bin/bash
###
# LIBs AUDIT script
#    Note setup crontab as:
#    03 03 * * * /home/ansible/playbooks/run_libs_audit.sh > /dev/null 2>&1
###

ANSIBLE_PLAY_PATH="/home/ansible/playbooks"
export ANSIBLE_CONFIG="$ANSIBLE_PLAY_PATH/ansible.cfg"
ANSIBLE_PARAMS="-e ansible_python_interpreter=auto_silent"
OUTPUT_PATH="/var/www/html/ansible"



### EU LIBs
OUTPUT_FILE=$OUTPUT_PATH/eu_libs/audit_eu_libs.$(date +"%Y-%m-%d_%Hh%M").out
OUTPUT_FILE2=${OUTPUT_FILE}.log
# Run Playbook
ansible-playbook $ANSIBLE_PARAMS -l eu_libs $ANSIBLE_PLAY_PATH/libs_audit.yml   2>&1 | tee $OUTPUT_FILE
# Log file adjustments
date -r $OUTPUT_FILE > $OUTPUT_FILE2
# Unreachables Hosts
cat $OUTPUT_FILE | grep "unreachable=1" >> $OUTPUT_FILE2
# LIBs commands outputs
cat $OUTPUT_FILE | grep -v "item" >> $OUTPUT_FILE2
rm -f ${OUTPUT_FILE}


### US LIBs
OUTPUT_FILE=$OUTPUT_PATH/us_libs/audit_us_libs.$(date +"%Y-%m-%d_%Hh%M").out
OUTPUT_FILE2=${OUTPUT_FILE}.log
ansible-playbook $ANSIBLE_PARAMS -l us_libs $ANSIBLE_PLAY_PATH/libs_audit.yml   2>&1 | tee $OUTPUT_FILE
# Log file adjustments
date -r $OUTPUT_FILE > $OUTPUT_FILE2
# Unreachables Hosts
cat $OUTPUT_FILE | grep "unreachable=1" >> $OUTPUT_FILE2
# LIBs commands outputs
cat $OUTPUT_FILE | grep -v "item" >> $OUTPUT_FILE2
rm -f ${OUTPUT_FILE}


### ASIA LIBs
OUTPUT_FILE=$OUTPUT_PATH/a_libs/audit_a_libs.$(date +"%Y-%m-%d_%Hh%M").out
OUTPUT_FILE2=${OUTPUT_FILE}.log
ansible-playbook $ANSIBLE_PARAMS -l a_libs $ANSIBLE_PLAY_PATH/libs_audit.yml   2>&1 | tee $OUTPUT_FILE
# Log file adjustments
date -r $OUTPUT_FILE > $OUTPUT_FILE2
# Unreachables Hosts
cat $OUTPUT_FILE | grep "unreachable=1" >> $OUTPUT_FILE2
# LIBs commands outputs
cat $OUTPUT_FILE | grep -v "item" >> $OUTPUT_FILE2
rm -f ${OUTPUT_FILE}



### LOG RETENTION
find $OUTPUT_PATH/eu_libs/ -mtime +30 -exec rm {} \;
find $OUTPUT_PATH/us_libs/ -mtime +30 -exec rm {} \;
find $OUTPUT_PATH/a_libs/ -mtime +30 -exec rm {} \;



### TREE - HTML OUTPUT
TREE_PARAMS="--noreport --charset utf-8 -r"
cd $OUTPUT_PATH && tree -T "ANSIBLE" -H '.' $TREE_PARAMS -d > index.html
cd $OUTPUT_PATH/eu_libs && tree -T "EU LIBs AUDIT" -H '.' $TREE_PARAMS -P "*.log" > index.html
cd $OUTPUT_PATH/us_libs && tree -T "US LIBs AUDIT" -H '.' $TREE_PARAMS -P "*.log" > index.html
cd $OUTPUT_PATH/a_libs && tree -T "ASIA LIBs AUDIT" -H '.' $TREE_PARAMS -P "*.log" > index.html


### RESET PRIVILEGES
chown -Rf ansible.ansible $OUTPUT_PATH/
