const joi = require("joi");
const CommonValidator = require("./commonValidator");
const HttpStatusCode = require("http-status-codes");

class MaterielTypesValidator extends CommonValidator {
  constructor() {}

  static async insert(req, res, next) {
    try {
      await joi
        .object({
          materielType: joi.string().max(256).required(),
          materielTypeName: joi.string().max(256).required(),
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
          materielType: joi.string().max(256),
          materielTypeName: joi.string().max(256),
          id: joi.number().required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }
}

module.exports = MaterielTypesValidator;
