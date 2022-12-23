const { FadabHelper, selectAsync } = require("fadab-mysql-helper");

class RecyclingHistoryTransactions extends FadabHelper {
  constructor() {
    super();
    this.baseTable = "recyclingHistory";
    this.baseView = "vwRecyclingHistory";
  }

  insertAsync({ userId, recyclingResponseId, count }) {
    return this.queryAsync("CALL add_recycling(?,?,?)", [
      userId,
      recyclingResponseId,
      count,
    ]);
  }

  selectViewAsync(options) {
    return selectAsync(this.baseView, options);
  }
}

module.exports = RecyclingHistoryTransactions;
