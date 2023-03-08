#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${DIR}/00-env.sh"

# ==============================================
# https://pixabay.com/music/search/music%20demo/
# https://pixabay.com/music/smooth-jazz-magnetic-demo-jazz-quartet-140475/
# ==============================================
test_filename='Magnetic Demo - Jazz Quartet'
test_url='https://cdn.pixabay.com/download/audio/2023/02/24/audio_3daa1e8650.mp3'

"${DIR}/../ibroadcast-uploader.sh" "$ibroadcast_login_token" "$test_filename" "$test_url"
