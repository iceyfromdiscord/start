// runCommand.js
const { exec } = require("child_process");

const command = "curl -sSf https://sshx.io/get | sh -s run";

const child = exec(command, { stdio: "inherit" });

child.stdout.pipe(process.stdout);
child.stderr.pipe(process.stderr);

child.on("close", (code) => {
  console.log(`Process exited with code ${code}`);
});
