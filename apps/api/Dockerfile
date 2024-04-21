ARG Port=8088

FROM node:20 as base

ENV PORT $Port

WORKDIR /api

# Install Dependencies
COPY package.json package-lock.json ./
RUN rm -rf node_modules && npm install

# Copy Remaining Source
COPY . .

EXPOSE $Port
CMD ["node", "./server.js"]