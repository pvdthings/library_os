const minify = require('../lib/minify')

const testThing = ({
    id,
    name,
    categories,
    image,
    stock
}) => {
    return {
        id: id ?? 'test_id',
        fields: {
            Name: name ?? 'test_name',
            Category: categories ?? ['test_category'],
            Image: [{
                thumbnails: {
                    large: {
                        url: image ?? 'test_image'
                    }
                }
            }],
            Stock: stock ?? 0
        }
    }
}

test('it maps [id]', () => {
    const thing = minify(testThing({ id: 'apricot' }))
    expect(thing.id).toBe('apricot')
})

test('it maps [name]', () => {
    const thing = minify(testThing({ name: 'Hammer' }))
    expect(thing.name).toBe('Hammer')
})

test('it maps [categories]', () => {
    const thing = minify(testThing({ categories: ['Outdoors', 'Entertainment'] }))
    expect(thing.categories).toEqual(['Outdoors', 'Entertainment'])
})

test('it maps [image]', () => {
    const thing = minify(testThing({ image: 'https://www.image.com' }))
    expect(thing.image).toBe('https://www.image.com')
})

test('it maps [stock]', () => {
    const thing = minify(testThing({ stock: 3 }))
    expect(thing.stock).toBe(3)
})