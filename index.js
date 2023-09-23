const express = require("express");
const app = express();
const { exec } = require("child_process");

app.post("/git/gitea-webhook", (req, res) => {
  //  exec(
  //     "/home/giteaHook/giteaHook.sh",
  //     (error, stdout, stderr) => {
  //       if (error) {
  //         console.log(`Error executing command: ${error}`);
  //         res.status(500).send("PULL ERROR")
  //       }
  //       res.status(200).send({mess: "PULL SUCCESS!", data: stdout})
  //       console.log(`Command output:\n${stdout}`);
  //     }
  //   );
  console.log("PULL2 EE333!!");
});

const PORT = 8000;
app.listen(PORT, () => {
  console.log("Server is running on port ", PORT);
});
