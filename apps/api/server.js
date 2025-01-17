require('dotenv').config();

const { isDevelopment } = require('./utils/environment');
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const things = require('./apps/catalog/routes/things');
const lending = require('./apps/librarian');
const cors = require('cors');
const helmet = require('helmet');
const apiKeyMiddleware = require('./middleware/apiKey');

const allowedOrigins = process.env.ACCESS_CONTROL_ALLOW_ORIGIN.split(',');

const corsOptions = Object.freeze({
    allowedHeaders: [
        'Origin',
        'x-api-key',
        'X-Requested-With',
        'Content-Type',
        'Accept',
        'x-access-token',
        'x-refresh-token'
    ],
    credentials: true,
    origin: (origin, callback) => {
        if (allowedOrigins.includes(origin) || !origin || isDevelopment()) {
            callback(null, true);
        } else {
            console.log('origin', origin);
            callback(new Error('CORS Error'));
        }
    }
});

app.use(cors(corsOptions));
app.use(helmet());
app.use(apiKeyMiddleware);
app.use(bodyParser.json());

app.use('/web', things);
app.use('/things', things);
app.use('/lending', lending);

app.use((req, res, next) => {
    res.status(404).send();
});

app.disable('x-powered-by');

const PORT = process.env.PORT || 8088;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}...`);
});