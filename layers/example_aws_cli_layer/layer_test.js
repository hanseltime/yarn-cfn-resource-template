/**
 * Simple test file to try and call the aws cli to ensure that it
 * is available on the path as we would use it.
 */
async function test() {
  const spawnSync = require('child_process').spawnSync
  const cliCall = spawnSync('aws', ['--version'], {
    stdio: 'pipe',
  })
  // Print the output or fail
  if (cliCall.error) {
    throw cliCall.error
  }
  if (cliCall.status && cliCall.status > 0) {
    throw new Error(`Unable to call the test command with a 0 code: ${cliCall.status}`)
  }
  if (cliCall.stdout.toString().trim().length === 0) {
    throw new Error('Unable to get meaningful output from command')
  }
  return 'SUCCESS'
}

module.exports = {
  test,
}
