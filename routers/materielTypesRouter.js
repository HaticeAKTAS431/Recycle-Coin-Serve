const router = require("express")();
const TransactionsFactory = require("../database/transactionFactory");
const { validators, verifyToken } = require("../middleware");
const materielTypesTransactions = TransactionsFactory.creating(
  "materielTypesTransactions"
);
const materielTypesValidator = validators.materielTypesValidator;
const tokenControl = verifyToken.tokenControl;
const HttpStatusCode = require("http-status-codes");
const { errorSender } = require("../utils");

router.post(
  "/materiel-types",
  tokenControl,
  materielTypesValidator.insert,
  async (req, res) => {
    try {
      const result = await materielTypesTransactions.insertAsync(req.body);
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
  "/materiel-types",
  tokenControl,
  materielTypesValidator.update,
  async (req, res) => {
    try {
      const result = await materielTypesTransactions.updateAsync(req.body, {
        id: req.body.id,
      });
      if (!result.affectedRows)
        throw errorSender.errorObject(
          HttpStatusCode.BAD_REQUEST,
          "An error occurred during the update process."
        );

      res.json("Update completed successfully.");
    } catch (error) {
      console.log({ error });
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.delete(
  "/materiel-types",
  tokenControl,
  materielTypesValidator.bodyId,
  async (req, res) => {
    try {
      const result = await materielTypesTransactions.deleteAsync(req.body);
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
  "/materiel-types",
  tokenControl,
  materielTypesValidator.limitAndOffset,
  async (req, res) => {
    try {
      const response = await materielTypesTransactions.selectAsync(req.query);
      res.json(response);
    } catch (error) {
      res
        .status(error.status || HttpStatusCode.INTERNAL_SERVER_ERROR)
        .send(error.message);
    }
  }
);

router.get(
  "/materiel-types/:id",
  tokenControl,
  materielTypesValidator.paramId,
  async (req, res) => {
    try {
      const response = await materielTypesTransactions.selectAsync({
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
