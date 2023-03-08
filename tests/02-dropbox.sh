#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${DIR}/00-env.sh"

test_filename='Moby Dick (free audiobook from Librivox)'
test_url='https://www.dropbox.com/s/123456789012345/Moby%20Dick.mp3?dl=1'

"${DIR}/../ibroadcast-uploader.sh" "$ibroadcast_login_token" "$test_filename" "$test_url" "$dropbox_session_cookie"
