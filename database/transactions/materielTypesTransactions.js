const { FadabHelper } = require("fadab-mysql-helper");

class MaterielTypesTransactions extends FadabHelper {
  constructor() {
    super();
    this.baseTable = "materielTypes";
  }
}

module.exports = MaterielTypesTransactions;
