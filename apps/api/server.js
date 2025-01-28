require('dotenv').config();

const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const things = require('./apps/catalog/routes/things');
const lending = require('./apps/librarian');
const helmet = require('helmet');
const apiKeyMiddleware = require('./middleware/apiKey');
const notFound = require('./middleware/notFound');
const rateLimit = require('./middleware/rateLimit');
const cors = require('./middleware/cors');

app.use(rateLimit);
app.use(cors);
app.use(helmet());
app.use(apiKeyMiddleware);
app.use(bodyParser.json());

app.use('/web', things);

if (!process.env.DISABLE_LENDING) {
    app.use('/lending', lending);
}

app.use(notFound);

app.disable('x-powered-by');

const PORT = process.env.PORT || 8088;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}...`);
});