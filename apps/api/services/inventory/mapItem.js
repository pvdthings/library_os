function mapItem(record) {
  const hidden = Boolean(record.get('Hidden'));
  const isThingHidden = record.get('is_thing_hidden') === 1;

  return {
      id: record.id,
      number: Number(record.get('ID')),
      name: record.get('Name')[0],
      available: record.get('Active Loans') === 0
          && !hidden
          && !isThingHidden,
      hidden: hidden || isThingHidden,
      brand: record.get('Brand'),
      description: record.get('Description'),
      estimatedValue: record.get('Estimated Value'),
      eyeProtection: Boolean(record.get('Eye Protection')),
      condition: record.get('Condition'),
      location: record.get('Location')?.[0],
      totalLoans: record.get('Total Loans'),
      images: record.get('Picture')?.map(image => image.thumbnails.large.url) || [],
      manuals: record.get('Manuals')?.map(manual => ({
        filename: manual.filename,
        url: manual.url 
      })) || []
  };
}

module.exports = mapItem;