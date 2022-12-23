const joi = require("joi");
const CommonValidator = require("./commonValidator");
const HttpStatusCode = require("http-status-codes");

class RecyclingHistoryValidator extends CommonValidator {
  constructor() {}

  static async insert(req, res, next) {
    try {
      await joi
        .object({
          userId: joi.number().max(256).required(),
          items: joi.array().items(
            joi.object({
              recyclingResponseId: joi.number().required(),
              count: joi.number().required(),
            })
          ),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }
}

module.exports = RecyclingHistoryValidator;
