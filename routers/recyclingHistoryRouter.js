const router = require("express")();
const TransactionsFactory = require("../database/transactionFactory");
const { validators, verifyToken } = require("../middleware");
const recyclingHistoryTransactions = TransactionsFactory.creating(
  "recyclingHistoryTransactions"
);
const recyclingHistoryValidator = validators.recyclingHistoryValidator;
const tokenControl = verifyToken.tokenControl;
const HttpStatusCode = require("http-status-codes");
const { errorSender } = require("../utils");

router.post(
  "/recycling-history",
  tokenControl,
  recyclingHistoryValidator.insert,
  async (req, res) => {
    try {
      for (const item of req.body.items)
        await recyclingHistoryTransactions.insertAsync({
          userId: req.body.userId,
          ...item,
        });

      res.json("Successfully added.");
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.get(
  "/recycling-history",
  tokenControl,
  recyclingHistoryValidator.limitAndOffset,
  async (req, res) => {
    try {
      const response = await recyclingHistoryTransactions.selectViewAsync({
        ...req.body,
        where: {
          userId: req.decode.userID,
        },
      });
      res.json(response);
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

module.exports = router;
