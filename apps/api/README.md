# PVD Things API

## Environment variables
You'll need to set these environment variables in a `.env` file at the root of the project folder:
```js
NODE_ENV=development // or 'production'

API_KEY=[value]

AIRTABLE_KEY=[value]
AIRTABLE_BASE_ID=[value]

SUPABASE_URL=[value]
SUPABASE_PUB_ANON_KEY=[value]

// Determines which users can access admin features
ADMIN_WHITELIST="alice@email.com"

// Webhook URL used for sending loan reminder messages
LOAN_REMINDER_WEBHOOK_URL=[value]

// Webhook URL used for updating loan due dates
UPDATE_DUE_DATES_WEBHOOK_URL=[value]
```

## Local Development

### Run the server
```js
npm run install // on first run
npm run start
```
The server will start on port `8088`.