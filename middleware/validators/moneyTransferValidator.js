const joi = require("joi");
const CommonValidator = require("./commonValidator");
const HttpStatusCode = require("http-status-codes");

class MoneyTransferValidator extends CommonValidator {
  constructor() {}

  static async insert(req, res, next) {
    try {
      await joi
        .object({
          recipientUserId: joi.number().max(256).required(),
          transferType: joi.number().max(256).required(),
          transferAmount: joi.number().required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }
}

module.exports = MoneyTransferValidator;
