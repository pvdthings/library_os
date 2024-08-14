function mapThing(record) {
  const available = Number(record.get('Available'));
  const stock = Number(record.get('Stock'));

  return {
      id: record.id,
      name: record.get('Name'),
      name_es: record.get('name_es'),
      stock,
      available,
      availableDate: record.get('Next Due Back')?.[0],
      images: record.get('Image')?.map(image => image.thumbnails.large.url) || [],
      categories: record.get('Category') || [],
      hidden: Boolean(record.get('Hidden'))
  };
}

module.exports = mapThing;