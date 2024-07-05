function mapThing(record) {
  const available = Number(record.get('Available'));
  const stock = Number(record.get('Stock'));

  const isAvailable = available > 0;
  const isWanted = stock === 0;

  return {
      id: record.id,
      name: record.get('Name'),
      name_es: record.get('name_es'),
      stock,
      available,
      availableDate: isAvailable || isWanted ? undefined : record.get('Next Due Back'),
      images: record.get('Image')?.map(image => image.url) || [],
      categories: record.get('Category') || [],
      hidden: Boolean(record.get('Hidden'))
  };
}

module.exports = mapThing;