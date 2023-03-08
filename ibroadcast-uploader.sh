#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

debugger=''

# =======================
# based on:
#   https://github.com/deseven/ibroadcast-uploader/blob/master/ibroadcast-uploader.py
#   version: 0.5
# =======================

app_name='iBroadcast bash uploader script'
app_useragent='ibroadcast-bash-uploader'
app_version='0.1.1'

user_id=''
user_token=''

print_usage() {
  echo 'usage: ibroadcast-uploader.sh <login_token> <filename> <URL> [<cookies>]'
}

do_login() {
  if [ -n "$user_id" -a -n "$user_token" ];then
    return 0
  fi

  local login_token="$1"

  local json=$(curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -H "User-Agent: ${app_useragent}/${app_version}" \
    --data-binary "{\"mode\": \"login_token\", \"login_token\": \"${login_token}\", \"app_id\": 1007, \"type\": \"account\", \"version\": \"${app_version}\", \"client\": \"${app_name}\", \"device_name\": \"${app_name}\", \"user_agent\": \"${app_useragent}/${app_version}\"}" \
    -s \
    'https://api.ibroadcast.com/s/JSON/')

  local parsed_json=$(echo "$json" | node "${DIR}/lib/parse_login_response.js")

  local sep=';'
  local array_parsed_json=(${parsed_json//$sep/ })

  if [ "${#array_parsed_json[@]}" == "2" ];then
    user_id="${array_parsed_json[0]}"
    user_token="${array_parsed_json[1]}"
  fi

  if [ "$debugger" == "1" ];then
    echo "json      = ${json}"
    echo "parsed    = ${parsed_json}"
    echo "  user id = ${user_id}"
    echo "  token   = ${user_token}"
    exit 0
  fi
}

do_upload() {
  local filename="$1"
  local url="$2"
  local cookies="$3"

  echo "uploading \"${filename}\"..."
  echo ''

  curl -L -H "Cookie: ${cookies}" -s "$url" | curl \
    -X POST \
    -F "file=@-;filename=${filename}" \
    -F "file_path=${filename}" \
    -F "user_id=${user_id}" \
    -F "token=${user_token}" \
    -F "method=${app_name}" \
    -s -S \
    'https://upload.ibroadcast.com'

  echo ''
}

main() {
  local login_token="$1"
  local filename="$2"
  local url="$3"
  local cookies="$4"

  if [ -z "$login_token" ];then
    echo 'missing required input parameter: login_token'
    print_usage
    exit 1
  fi
  if [ -z "$filename" ];then
    echo 'missing required input parameter: filename'
    print_usage
    exit 1
  fi
  if [ -z "$url" ];then
    echo 'missing required input parameter: URL'
    print_usage
    exit 1
  fi

  do_login "$login_token"

  if [ -z "$user_id" -o -z "$user_token" ];then
    echo 'account login failed'
    exit 1
  fi

  do_upload "$filename" "$url" "$cookies"
}

main "$1" "$2" "$3" "$4"
