const fs = require("fs");
const express = require("express");
const app = express();
const { exec } = require("child_process");
const nodeMailer = require("nodemailer");
const contentFile = fs.readFileSync(
  "./service_run/giteaService.conf",
  "utf8"
);

const PORT = contentFile
    .split("\n")
    .filter((i) => i.includes("PORT_SERVICE"))[0]
    ?.split("=")[1]
    .trim();
app.use(express.json());

app.post("/git/gitea-webhook", async (req, res) => {
  let title = ""
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
  const giteaEvent = req.headers["x-gitea-event"];
  console.log("New event: " + giteaEvent);
  const body = req.body;
  //console.log(body)
  res
    .status(200)
    .send({ mess: "The event has been received!", data: req.body });

  exec("./service_run/giteaHook.sh", (error, stdout, stderr) => {
    let content = stdout !== ""? stdout : stderr
    if (error) {
      console.log("Pull failed. Please check");
      console.log(`Error executing command: ${error}`);
      title += "New Git envent: " + giteaEvent + "(error)"
    }else{
      console.log(stdout);
      
      if(stderr.includes("Error") || stderr.includes("failed") || stdout.includes("Error") || stdout.includes("failed")){
        title += "New Git envent: " + giteaEvent + "(error)"
      }else{
        title += "New Git envent: " + giteaEvent + "(success)"
      }
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
});

app.listen(PORT, () => {
  console.log("Service is running on port ", PORT);
});
