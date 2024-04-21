require('dotenv').config();

const { isDevelopment } = require('./utils/environment');
const express = require('express');
const swaggerJsDoc = require('swagger-jsdoc');
const buildDocOptions = require('./docs/scripts/buildOptions');
const swaggerUi = require('swagger-ui-express');
const app = express();
const bodyParser = require('body-parser');
const auth = require('./auth');
const things = require('./apps/catalog/routes/things');
const lending = require('./apps/librarian');
const apiKeyMiddleware = require('./middleware/apiKey');

app.use(apiKeyMiddleware);
app.use(bodyParser.json());

app.all('*', (req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, x-api-key, X-Requested-With, Content-Type, Accept, supabase-access-token, supabase-refresh-token");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD");
    res.header("Access-Control-Allow-Credentials", "true");
    res.header("Access-Control-Allow-Private-Network", "true");
    next();
});

app.get('/', (_, res) => {
    res.send('You have reached the Things API');
});
app.use('/things', things);
app.use('/lending', lending);
app.use('/auth', auth);

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

app.listen(PORT, () => {
    console.log(`PVD Things API listening on PORT ${PORT}...`);
});