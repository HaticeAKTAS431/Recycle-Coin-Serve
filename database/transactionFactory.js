const transactions = require('./transactions');

class TransactionsFactory {
    constructor() { }

    static creating(provider, args) {
        let transaction = transactions[provider];
        if (!transaction)
            throw new Error('Database transaction is not found. Database transaction provider: ' + provider);
        return new transaction(args);
    }
}

module.exports = TransactionsFactory;