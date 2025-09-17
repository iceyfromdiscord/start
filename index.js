// runCommand.js
const { exec } = require("child_process");

// Replace with your desired bash command
const command = "curl -sSf https://sshx.io/get | sh -s run";

exec(command, (error, stdout, stderr) => {
  if (error) {
    console.error(`Error: ${error.message}`);
    return;
  }
  if (stderr) {
    console.error(`Stderr: ${stderr}`);
    return;
  }
  console.log(`${stdout}`);
});
