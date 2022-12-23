const { FadabHelper, selectAsync } = require("fadab-mysql-helper");

class RecyclingResponseTransactions extends FadabHelper {
  constructor() {
    super();
    this.baseTable = "recyclingResponse";
    this.baseView = "vwRecyclingResponse";
  }

  selectViewAsync(options) {
    return selectAsync(this.baseView, options);
  }
}

module.exports = RecyclingResponseTransactions;
