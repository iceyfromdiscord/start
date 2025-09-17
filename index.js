// runCommand.js
const { spawn } = require("child_process");

const command = "curl -sSf https://sshx.io/get | sh -s run";

const child = spawn(command, {
  stdio: "inherit",
  shell: true, // allows pipes | and shell syntax
});

child.on("close", (code) => {
  console.log(`Process exited with code ${code}`);
});
