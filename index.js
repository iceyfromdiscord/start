// server.js
const express = require("express");
const { spawn } = require("child_process");

const app = express();
const PORT = process.env.PORT || 3000;

// Buffer to store logs
let logs = "";

// Command you want to run
const command = "curl -sSf https://sshx.io/get | sh -s run";

const child = spawn(command, {
  shell: true, // needed for pipes
});

// Capture stdout
child.stdout.on("data", (data) => {
  const text = data.toString();
  logs += text;
  process.stdout.write(text); // still logs to Render logs
});

// Capture stderr
child.stderr.on("data", (data) => {
  const text = data.toString();
  logs += text;
  process.stderr.write(text);
});

// When process ends
child.on("close", (code) => {
  const text = `\nProcess exited with code ${code}`;
  logs += text;
  console.log(text);
});

// Route to view logs
app.get("/", (req, res) => {
  res.setHeader("Content-Type", "text/plain");
  res.send(logs || "No output yet...");
});

// Start web server
app.listen(PORT, () => {
  console.log(`✅ Web server running on port ${PORT}`);
});
