require('dotenv').config();

const { isDevelopment } = require('./utils/environment');
const express = require('express');
const swaggerJsDoc = require('swagger-jsdoc');
const buildDocOptions = require('./docs/scripts/buildOptions');
const swaggerUi = require('swagger-ui-express');
const app = express();
const bodyParser = require('body-parser');
// const auth = require('./auth');
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
        'supabase-access-token',
        'supabase-refresh-token'
    ],
    credentials: true,
    origin: (origin, callback) => {
        if (allowedOrigins.includes(origin) || !origin) {
            callback(null, true);
        } else {
            callback(new Error('Not allowed by CORS'));
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
// app.use('/auth', auth);

app.use((req, res, next) => {
    res.status(404).send();
});

const PORT = process.env.PORT || 8088;

if (isDevelopment()) {
    const docOptions = buildDocOptions({ port: PORT });
    const specs = swaggerJsDoc(docOptions);

    app.use(
        '/docs',
        swaggerUi.serve,
        swaggerUi.setup(specs, { explorer: true })
    );
}

app.disable('x-powered-by');

app.listen(PORT, () => {
    console.log(`PVD Things API listening on PORT ${PORT}...`);
});