function mapThingDetails(record, items) {
  return {
      id: record.id,
      name: record.get('Name'),
      name_es: record.get('name_es'),
      stock: Number(record.get('Stock')),
      available: Number(record.get('Available')),
      hidden: Boolean(record.get('Hidden')),
      categories: record.get('Category') || [],
      eyeProtection: Boolean(record.get('Eye Protection')),
      images: record.get('Image')?.map(i => ({
          id: i.id,
          url: i.url,
          width: i.width,
          height: i.height,
          type: i.type
      })) || [],
      items
  };
}

module.exports = mapThingDetails;