const { base, Table } = require('../../db');

const payments = base(Table.Payments);

const fetchPayments = async (borrowerId) => {
    const records = await payments.select({
        filterByFormula: `{member_id} = "${borrowerId}"`,
        sort: [{ field: 'date', direction: 'desc' }]
    }).all();

    return records.map(r => ({
        id: r.id,
        date: r.get('date')
    }));
};

const recordCashPayment = async ({
    borrowerId
}) => {
    const payment = await payments.create({
        "member": [borrowerId]
    });

    return payment.id;
};

module.exports = {
    fetchPayments,
    recordCashPayment
};