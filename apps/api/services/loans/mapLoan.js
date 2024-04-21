function mapLoan(loan, itemId) {
  const thingNames = loan.get('Borrowed Things');
    const itemIndex = loan.get('Things').indexOf(itemId);
    const itemNumber = loan.get('thing_numbers')[itemIndex];

  return {
    id: loan.id,
    number: Number(loan.get('Loan')),
    borrower: {
      id: loan.get('Borrower')[0],
      name: loan.get('Borrower Name')[0]
    },
    thing: {
      id: itemId,
      number: Number(itemNumber),
      name: thingNames[itemIndex]
    },
    checkedOutDate: loan.get('Checked Out'),
    checkedInDate: loan.get('checked_in_date'),
    dueBackDate: loan.get('Due Back')
  };
}

module.exports = mapLoan;