function mapThing(record) {
  return {
      id: record.id,
      name: record.get('Name'),
      name_es: record.get('name_es'),
      stock: Number(record.get('Stock')),
      available: Number(record.get('Available')),
      images: record.get('Image')?.map(image => image.url) || [],
      categories: record.get('Category') || [],
      hidden: Boolean(record.get('Hidden'))
  };
}

module.exports = mapThing;