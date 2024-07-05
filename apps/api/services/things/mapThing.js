function mapThing(record) {
  const available = Number(record.get('Available'));

  return {
      id: record.id,
      name: record.get('Name'),
      name_es: record.get('name_es'),
      stock: Number(record.get('Stock')),
      available,
      availableDate: available > 0 ? undefined : record.get('Next Due Back'),
      images: record.get('Image')?.map(image => image.url) || [],
      categories: record.get('Category') || [],
      hidden: Boolean(record.get('Hidden'))
  };
}

module.exports = mapThing;