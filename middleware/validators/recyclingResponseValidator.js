const joi = require("joi");
const CommonValidator = require("./commonValidator");
const HttpStatusCode = require("http-status-codes");

class RecyclingResponseValidator extends CommonValidator {
  constructor() {}

  static async insert(req, res, next) {
    try {
      await joi
        .object({
          materielName: joi.string().max(256).required(),
          materielTypeId: joi.number().required(),
          price: joi.number().required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }

  static async update(req, res, next) {
    try {
      await joi
        .object({
          materielName: joi.string().max(256),
          materielTypeId: joi.number(),
          price: joi.number(),
          id: joi.number().required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }
}

module.exports = RecyclingResponseValidator;
