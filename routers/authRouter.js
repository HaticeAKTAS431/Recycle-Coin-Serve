const router = require("express")();
const jwt = require("jsonwebtoken");
const TransactionsFactory = require("../database/transactionFactory");
const { validators, verifyToken } = require("../middleware");
const userTransactions = TransactionsFactory.creating("userTransactions");
const authValidator = validators.authValidator;
const tokenControl = verifyToken.tokenControl;
const HttpStatusCode = require("http-status-codes");
const { errorSender, random, smtp } = require("../utils");

router.post("/login", authValidator.login, async (req, res) => {
  try {
    const result = await userTransactions.findOneAsync(req.body);
    if (!result)
      throw errorSender.errorObject(
        HttpStatusCode.BAD_REQUEST,
        "Check your email address or password !"
      );

    const payload = {
      userID: result.id,
      userType: result.userType,
    };
    const token = jwt.sign(payload, req.app.get("api_key"), {
      expiresIn: "7d",
    });
    res.json({ result, token });
  } catch (error) {
    res
      .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
      .send(error.message);
  }
});

router.post("/register", authValidator.register, async (req, res) => {
  try {
    if (
      await userTransactions.findOneAsync({
        email: req.body.email,
      })
    )
      throw errorSender.errorObject(
        HttpStatusCode.BAD_REQUEST,
        "This e-mail address is registered in the system!"
      );

    const user = await userTransactions.insertAsync(req.body);
    if (!user)
      throw errorSender.errorObject(
        HttpStatusCode.BAD_REQUEST,
        "Something went wrong!"
      );

    res.json("User registired succesfully.");
  } catch (error) {
    res
      .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
      .send(error.message);
  }
});

router.put(
  "/change-password",
  tokenControl,
  authValidator.changePassword,
  async (req, res) => {
    try {
      const result = await userTransactions.updateAsync(
        { password: req.body.newPassword },
        { id: req.decode.userID, password: req.body.password }
      );
      if (!result.affectedRows)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "Wrong password !"
        );
      res.json("Your password has been changed.");
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.post(
  "/forgot-password",
  authValidator.forgotPassword,
  async (req, res) => {
    try {
      const user = await userTransactions.findOneAsync({
        email: req.body.email,
      });
      if (!user)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "The e-mail address is not registered in the system!"
        );

      const recoveryCode = random.generate({ length: 10 });
      const updateResult = await userTransactions.updateAsync(
        { recoveryCode },
        { id: user.id }
      );
      if (!updateResult.affectedRows)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "Failed to generate verification code!"
        );

      await smtp.sendEmailAsync({
        to: user.email,
        subject: "Şifremi Sıfırlama",
        text: `Şifre sıfırlama kodunuz: ${recoveryCode}`,
      });
      res.json("Rescue mail sent");
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.put("/reset-password", authValidator.resetPassword, async (req, res) => {
  try {
    const user = await userTransactions.findOneAsync({
      email: req.body.email,
      recoveryCode: req.body.recoveryCode,
    });
    if (!user)
      throw errorSender.errorObject(
        HttpStatusCode.BAD_REQUEST,
        "Recovery code is incorrect"
      );

    const updatePasswordResult = await userTransactions.updateAsync(
      { recoveryCode: "", password: req.body.newPassword },
      { id: user.id }
    );

    if (!updatePasswordResult.affectedRows)
      throw errorSender.errorObject(
        HttpStatusCode.BAD_REQUEST,
        "Password not reset!"
      );

    res.json("Your password has been changed.");
  } catch (error) {
    res
      .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
      .send(error.message);
  }
});

router.get("/token-decode", tokenControl, async (req, res) => {
  res.json(req.decode);
});

module.exports = router;
