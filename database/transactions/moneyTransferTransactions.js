const { FadabHelper, selectAsync } = require("fadab-mysql-helper");

class MoneyTransferTransactions extends FadabHelper {
  constructor() {
    super();
    this.baseTable = "moneyTransfer";
    this.baseView = "vwMoneyTransfer";
  }

  insertAsync({ senderUserId, recipientUserId, transferType, transferAmount }) {
    return this.queryAsync("Call transfer_money(?,?,?,?)", [
      recipientUserId,
      senderUserId,
      transferType,
      transferAmount,
    ]);
  }

  selectViewAsync(options) {
    return selectAsync(this.baseView, options);
  }
}

module.exports = MoneyTransferTransactions;
