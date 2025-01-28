const notFound = (req, res, next) => {
    res.status(404).send();
};

module.exports = notFound;