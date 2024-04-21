const { base, Table } = require('../../db');

const payments = base(Table.Payments);

const fetchPayments = async (borrowerId) => {
    const records = await payments.select({
        filterByFormula: `{member_id} = "${borrowerId}"`,
        sort: [{ field: 'date', direction: 'desc' }]
    }).all();

    return records.map(r => ({
        id: r.id,
        cash: r.get('cash'),
        date: r.get('date')
    }));
};

const recordCashPayment = async ({
    borrowerId,
    cash
}) => {
    const today = new Date(Date.now());
    const payment = await payments.create({
        "member": [borrowerId],
        "date": today.toISOString(),
        cash
    });

    return payment.id;
};

module.exports = {
    fetchPayments,
    recordCashPayment
};