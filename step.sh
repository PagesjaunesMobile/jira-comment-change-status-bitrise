#!/bin/bash
# fail if any commands fails
#set -e
# debug log
set -x
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

envman add --key BITRISE_GIT_BRANCH --value "develop"

PJ_BUILD_VERSION=8.7
PJ_BUILD_NUMBER=17071550

#extraire le numero de jira depuis le message du commit
#commit_msg="$CHANGELOG"
commit_msg="cn [#TM-163] klk;n d [#TM-164]jkhdk[#TM-162]j"
#commit_msg="cnqdfqdfqfqsfqs fqsdfqsfqsfj"

numero_jira="$(echo "$commit_msg" | grep -o '\[#[a-zA-Z.0-9.-]*\]' | sed 's/\[#//g' | sed 's/\]//g')"
#supprimer les espaces
numero_jira="$(echo "$numero_jira" | tr -d ' ')"
#supprimer les doublon
numero_jira="$(echo "$numero_jira" | xargs -n1 | sort -u | xargs)"



for jira in $numero_jira; do
curl -D- -u $LOGIN_JIRA:$PASS_JIRA -X POST --data "{\"body\":\"Le correctif de cette jira est passé sur la branche $BITRISE_GIT_BRANCH \n La version $PJ_BUILD_VERSION $PJ_BUILD_NUMBER est disponible sur Beta .\"}" -H "Content-Type: application/json" $JIRA_URL/rest/api/2/issue/$jira/comment -v
#changer le status en correction
curl -D- -u $LOGIN_JIRA:$PASS_JIRA -X POST  --data "{\"transition\":{\"id\":\"761\"}}" -H "Content-Type: application/json" $JIRA_URL/rest/api/2/issue/$jira/transitions?expand=transitions.fields -v
#changer le status en livraison
curl -D- -u $LOGIN_JIRA:$PASS_JIRA -X POST  --data "{\"transition\":{\"id\":\"771\"}}" -H "Content-Type: application/json" $JIRA_URL/rest/api/2/issue/$jira/transitions?expand=transitions.fields -v

done



#envman add --key NUM_JIRA --value "$numero_jira"
#deduire le nom du projet depuis le numero du jira
#projet_jira="$(echo "$numero_jira" | sed 's/-.*//')"
#if  [[ "$projet_jira" == MOBTHOR ]]
#then
# envman add --key PROJET_JIRA --value "Mobile-THOR"
#elif  [[ "$projet_jira" == MOBNAKAMA ]]
#then
# envman add --key PROJET_JIRA --value "Mobile-NAKAMA"
#elif  [[ "$projet_jira" == MOBCOSI ]]
#then
#  envman add --key PROJET_JIRA --value "Mobile-COSI"
#elif  [[ "$projet_jira"  == MOBSHARP ]]
#then
#  envman add --key PROJET_JIRA --value "Mobile-SHARP"
#elif  [[ "$projet_jira" == MOBSNATCH ]]
#then
#  envman add --key PROJET_JIRA --value "Mobile-SNATCH"
#else
#  envman add --key PROJET_JIRA --value ""
  #      echo "Aucun projet ne correspond a cette jira"
#fi
