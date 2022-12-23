const router = require("express")();
const TransactionsFactory = require("../database/transactionFactory");
const { validators, verifyToken } = require("../middleware");
const recyclingResponseTransactions = TransactionsFactory.creating(
  "recyclingResponseTransactions"
);
const recyclingResponseValidator = validators.recyclingResponseValidator;
const tokenControl = verifyToken.tokenControl;
const HttpStatusCode = require("http-status-codes");
const { errorSender } = require("../utils");

router.post(
  "/recycling-response",
  tokenControl,
  recyclingResponseValidator.insert,
  async (req, res) => {
    try {
      const result = await recyclingResponseTransactions.insertAsync(req.body);
      if (!result.affectedRows)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "An error occurred during the insertion process."
        );

      res.json("Adding completed successfully.");
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.put(
  "/recycling-response",
  tokenControl,
  recyclingResponseValidator.update,
  async (req, res) => {
    try {
      const result = await recyclingResponseTransactions.updateAsync(req.body, {
        id: req.body.id,
      });
      if (!result.affectedRows)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "An error occurred during the update process."
        );

      res.json("Update completed successfully.");
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.delete(
  "/recycling-response",
  tokenControl,
  recyclingResponseValidator.bodyId,
  async (req, res) => {
    try {
      const result = await recyclingResponseTransactions.deleteAsync(req.body);
      if (!result.affectedRows)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "An error occurred while deleting."
        );

      res.json("Delete completed successfully.");
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.get(
  "/recycling-response",
  tokenControl,
  recyclingResponseValidator.limitAndOffset,
  async (req, res) => {
    try {
      const response = await recyclingResponseTransactions.selectViewAsync(
        req.query
      );
      res.json(response);
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.get(
  "/recycling-response/:id",
  tokenControl,
  recyclingResponseValidator.paramId,
  async (req, res) => {
    try {
      const response = await recyclingResponseTransactions.selectViewAsync({
        where: req.params,
      });

      if (!response.length)
        throw errorSender.errorObject(HttpStatusCode.NOT_FOUND, "Not found!");

      res.json(response[0]);
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

module.exports = router;
