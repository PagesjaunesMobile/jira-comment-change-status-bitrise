#!/bin/bash
# fail if any commands fails
#set -e
# debug log
set -x

#extraire le numero de jira depuis le message du commit
commit_msg="$CHANGELOG"

numero_jira="$(echo "$commit_msg" | grep -o '\[#[a-zA-Z.0-9.-]*\]' | sed 's/\[#//g' | sed 's/\]//g')"
#supprimer les espaces
numero_jira="$(echo "$numero_jira" | tr -d ' ')"
#supprimer les doublon
numero_jira="$(echo "$numero_jira" | xargs -n1 | sort -u | xargs)"



for jira in $numero_jira; do
curl -D- -u $LOGIN_JIRA:$PASS_JIRA -X POST --data "{\"body\":\"Le correctif de cette jira est passé sur la branche $BITRISE_GIT_BRANCH \n La version $PJ_BUILD_VERSION $PJ_BUILD_NUMBER est disponible sur Beta .\n[Voir le détail du build|$BITRISE_BUILD_URL]\"}" -H "Content-Type: application/json" $JIRA_URL/rest/api/2/issue/$jira/comment -v
#changer le status en correction
curl -D- -u $LOGIN_JIRA:$PASS_JIRA -X POST  --data "{\"transition\":{\"id\":\"761\"}}" -H "Content-Type: application/json" $JIRA_URL/rest/api/2/issue/$jira/transitions?expand=transitions.fields -v
#changer le status en livraison
curl -D- -u $LOGIN_JIRA:$PASS_JIRA -X POST  --data "{\"transition\":{\"id\":\"771\"}}" -H "Content-Type: application/json" $JIRA_URL/rest/api/2/issue/$jira/transitions?expand=transitions.fields -v

done

