// server.js
const express = require("express");
const { spawn } = require("child_process");

const app = express();
const PORT = process.env.PORT || 3000;

// Buffer to store logs
let logs = "";
// Route to view logs
app.get("/", (req, res) => {
  res.send("hi")
});

// Start web server
app.listen(PORT, () => {
  console.log(`✅ Web server running on port ${PORT}`);
});
