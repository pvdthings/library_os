function mapLoanDetails(loan, item) {
  const email = loan.get('Borrower Email');
  const phone = loan.get('Borrower Phone');

  const itemImages = item.get('Picture')?.map((image) => image.thumbnails.large.url) || [];
  const thingImages = item.get('Image')?.map((image) => image.thumbnails.large.url) || [];
  const images = [...itemImages, ...thingImages].filter((url) => url);

  return {
    id: loan.id,
    number: Number(loan.get('Loan')),
    borrower: {
      id: loan.get('Borrower')[0],
      name: loan.get('Borrower Name')[0],
      contact: {
        email: email ? email[0] : undefined,
        phone: phone ? phone[0] : undefined
      }
    },
    thing: {
      id: item.id,
      number: Number(item.get('ID')),
      name: item.get('Name')[0],
      images
    },
    notes: loan.get('Notes'),
    extensions: loan.get('extensions_count'),
    checkedOutDate: loan.get('Checked Out'),
    checkedInDate: loan.get('checked_in_date'),
    dueBackDate: loan.get('Due Back'),
    remindersSent: Number(loan.get('reminders_sent')) || 0
  };
}

module.exports = mapLoanDetails;