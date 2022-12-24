const router = require("express")();
const TransactionsFactory = require("../database/transactionFactory");
const { validators, verifyToken } = require("../middleware");
const userTransactions = TransactionsFactory.creating("userTransactions");
const moneyTransferTransactions = TransactionsFactory.creating(
  "moneyTransferTransactions"
);
const moneyTransferValidator = validators.moneyTransferValidator;
const tokenControl = verifyToken.tokenControl;
const HttpStatusCode = require("http-status-codes");
const { errorSender } = require("../utils");

router.post(
  "/money-transfer",
  tokenControl,
  moneyTransferValidator.insert,
  async (req, res) => {
    try {
      const response = await moneyTransferTransactions.insertAsync({
        ...req.body,
        senderUserId: req.decode.userID,
      });

      if (response[1].affectedRows == 2)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "Insufficient balance!"
        );
      res.json("Transfer successful.");
    } catch (error) {
      console.log({ error });
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.get(
  "/money-transfer",
  tokenControl,
  moneyTransferValidator.limitAndOffset,
  async (req, res) => {
    try {
      const response = await moneyTransferTransactions.selectViewAsync({
        ...req.body,
        where: {
          _or: {
            senderUserId: req.decode.userID,
            recipientUserId: req.decode.userID,
          },
        },
      });
      res.json(response);
    } catch (error) {
      console.log({ error });
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

module.exports = router;
