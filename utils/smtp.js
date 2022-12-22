const nodemailer = require("nodemailer");

class Smtp {
  static sendEmailAsync({ to, subject, text }) {
    let transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT,
      auth: {
        user: process.env.SMTP_USER_NAME, // generated ethereal user
        pass: process.env.SMTP_PASSWORD, // generated ethereal password
      },
    });

    return transporter.sendMail({
      from: process.env.SMTP_FROM,
      to,
      subject,
      text,
    });
  }
}

module.exports = Smtp;
