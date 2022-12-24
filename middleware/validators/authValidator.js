const joi = require("joi");
const HttpStatusCode = require("http-status-codes");

class AuthValidator {
  constructor() {}

  static async login(req, res, next) {
    try {
      await joi
        .object({
          email: joi.string().email().max(256).required(),
          password: joi.string().max(256).required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }

  static async register(req, res, next) {
    try {
      await joi
        .object({
          firstName: joi.string().max(256).required(),
          surName: joi.string().max(256).required(),
          phone: joi.string().max(25).required(),
          email: joi.string().email().max(256).required(),
          password: joi.string().max(256).required(),
          userType: joi.string().max(50).required(),
          birthyear: joi.number().required(),
          identityNo: joi.string().required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }

  static async changePassword(req, res, next) {
    try {
      await joi
        .object({
          password: joi.string().max(256).required(),
          newPassword: joi.string().max(256).required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }

  static async forgotPassword(req, res, next) {
    try {
      await joi
        .object({
          email: joi.string().email().max(256).required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }

  static async resetPassword(req, res, next) {
    try {
      await joi
        .object({
          email: joi.string().email().max(256).required(),
          recoveryCode: joi.string().max(10).min(10).required(),
          newPassword: joi.string().required(),
        })
        .validateAsync(req.body);
      next();
    } catch (err) {
      res.status(HttpStatusCode.EXPECTATION_FAILED).send(err.message);
    }
  }
}

module.exports = AuthValidator;
