const fs = require("fs");
const express = require("express");
const app = express();
const { exec } = require("child_process");
const nodeMailer = require("nodemailer");
const contentFile = fs.readFileSync("./service_run/giteaService.conf", "utf8");
let checkStatus = "ready"
// const checkFile = fs.readFileSync("./service_run/checkFile", "utf8");
const PORT = contentFile
  .split("\n")
  .filter((i) => i.includes("PORT_SERVICE"))[0]
  ?.split("=")[1]
  .trim();
app.use(express.json());

app.post("/git/gitea-webhook", async (req, res) => {
  let title = "";

  const checkSendMail = contentFile
    .split("\n")
    .filter((i) => i.includes("SEND_EMAIL"))[0]
    ?.split("=")[1]
    .trim();

  const emailAddress = contentFile
    .split("\n")
    .filter((i) => i.includes("EMAIL_ADDRESS"))[0]
    ?.split("=")[1]
    .trim();

  const FE_Path = contentFile
    .split("\n")
    .filter((i) => i.includes("FE_PROJECT_PATH"))[0]
    ?.split("=")[1]
    .trim();

  const giteaEvent = req.headers["x-gitea-event"];

  const body = req.body;
  //console.log(body)
  res
    .status(200)
    .send({ mess: "The event has been received!", data: req.body });
  console.log("CHECK FILE", checkStatus);
  if (checkStatus === "busy") {
    const transporter = nodeMailer.createTransport({
      pool: true,
      host: "mail.ipsupply.com.au",
      port: 465,
      secure: true,
      auth: {
        user: "admin@apactech.io",
        pass: "BGK!dyt6upd2eax1bhz",
      },
    });

    const options = {
      from: "admin@apactech.io",
      to: emailAddress,
      subject: "Git notifications (Fail)",
      html:
        "<h3>There is an active build process in the " +
        FE_Path +
        " directory. Please check and push again in a few minutes.</h3>",
    };

    return transporter.sendMail(options);
  } else {
    console.log("New event: " + giteaEvent);
    // fs.writeFileSync("./service_run/checkFile", "true");
    checkStatus="busy"
    exec("./service_run/giteaHook.sh", (error, stdout, stderr) => {
      let content = stdout !== "" ? stdout : stderr;
      if (error) {
        console.log("Pull failed. Please check");
        console.log(`Error executing command: ${error}`);
        title += "New Git envent: " + giteaEvent;
      } else {
        console.log(stdout);
        if (
          stderr.includes("Error") ||
          stderr.includes("failed") ||
          stdout.includes("Error") ||
          stdout.includes("failed")
        ) {
          title += "New Git envent: " + giteaEvent;
        } else {
          title += "New Git envent: " + giteaEvent + "(success)";
        }
        setTimeout(() => {
          
          checkStatus="ready"
          // fs.writeFileSync("./service_run/checkFile", "false");
          
        }, 10000);
      }

      if (checkSendMail === "True") {
        const transporter = nodeMailer.createTransport({
          pool: true,
          host: "mail.ipsupply.com.au",
          port: 465,
          secure: true,
          auth: {
            user: "admin@apactech.io",
            pass: "BGK!dyt6upd2eax1bhz",
          },
        });

        const options = {
          from: "admin@apactech.io",
          to: emailAddress,
          subject: title,
          html:
            "<h1>*** " +
            giteaEvent +
            " event ***</h1><h4>Committer: " +
            req.body.commits[0]?.committer.name +
            "</h4><h4>Message: " +
            req.body.commits[0]?.message +
            "</h4><h4>Branch: " +
            req.body.ref +
            "</h4><a href='" +
            req.body.commits[0]?.url +
            "'>Link: " +
            req.body.commits[0]?.url +
            "</a><h4>Process output:</h4><textarea style='wordWrap:break-word; display: block; width:100%; height:70vh;border:solid 2px orange'>" +
            content +
            "</textarea>",
        };

        return transporter.sendMail(options);
      }
    });
  }
});

app.listen(PORT, () => {
  console.log("Service is running on port ", PORT);
});
