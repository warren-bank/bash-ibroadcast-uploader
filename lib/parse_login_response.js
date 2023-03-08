const fs = require('fs')

const sep = ';'

try {
  const json = fs.readFileSync(process.stdin.fd, 'utf8')
  const data = JSON.parse(json)

  if (!data || !data.result || !(data.message.toLowerCase() === 'ok') || !data.user)
    throw ''

  const user_id    = data.user.id
  const user_token = data.user.token

  process.stdout.write(`${user_id}${sep}${user_token}`)
}
catch(e) {
  process.exit(1)
}
