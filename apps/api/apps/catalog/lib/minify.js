const minify = (thing) => {
    return {
        id: thing.id,
        name: thing.name,
        categories: thing.categories,
        image: thing.images.length > 0 ? thing.images[0] : null,
        stock: thing.stock,
        available: thing.available,
        availableDate: thing.availableDate,
        spanishName: thing.name_es
    };
}

module.exports = minify;