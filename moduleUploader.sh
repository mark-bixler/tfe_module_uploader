#!/bin/bash
# https://www.terraform.io/docs/enterprise/api/modules.html

################################################################################
### Set Variables ###
################################################################################
url=$PTFE_URL               # Your PTFE Server URL
name=${PWD##*/}             # Uses current working directory name
org=$PTFE_ORG               # Your PTFE Organization
provider=$PTFE_PROVIDER     # Your Module Provider

################################################################################
### Help ###
################################################################################
if [ "$1" == "-h" ]; then
  echo
  echo "Usage: ./`basename $0` [TOKEN]"
  echo
  echo "eg. ./`basename $0` TOKEN=aFoFQ4nLtgkA19g.atl...."
  echo
  exit 0
fi

################################################################################
### New or existing module ###
################################################################################
read -p "New or Existing Module? [New]: " mod
mod=${mod:-New}
if [[ $(tr "[:upper:]" "[:lower:]" <<<$mod) -ne "existing" ]] || \
    [[ $(tr "[:upper:]" "[:lower:]" <<<$mod) -ne "new" ]];
then
  echo "Invalid response. Quitting.."
  exit
fi
################################################################################
create_new_module()
{
  cat <<EOF
{
  "data": {
    "type": "registry-modules",
    "attributes": {
      "name": "$name",
      "provider": "$provider"
    }
  }
}
EOF
}
################################################################################
create_module_version()
{
  cat <<EOF
{
  "data": {
    "type": "registry-module-versions",
    "attributes": {
      "version": "$version"
    }
  }
}
EOF
}
################################################################################
### Create Module ###
################################################################################
 if [[ $(tr "[:upper:]" "[:lower:]" <<<$mod) = "new" ]];
 then
  curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data "$(create_new_module)" \
    $url/api/v2/organizations/$org/registry-modules 

  version="1.0.0" 
else
  echo -n "Enter module version number [eg. 1.0.0]: "
  read version
fi

################################################################################
### Create Module Version
################################################################################

output=`curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data "$(create_module_version)" \
  $url/api/v2/registry-modules/$org/$name/$provider/versions`

uploadUrl=$(echo $output | awk -F 'upload":"' '{print substr($2, 1, length($2)-4)}')

################################################################################
### Archive Module Directory
################################################################################

tar zcvf $name.$version.tar.gz *

################################################################################
### Upload Module
################################################################################

curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @$name.$version.tar.gz \
  $uploadUrl

  rm $name.$version.tar.gz