function mapItemStatus(item) {
  if (item.available) {
    return 'available';
  }

  return 'checkedOut';
}

module.exports = mapItemStatus;