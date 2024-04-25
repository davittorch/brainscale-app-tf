FROM node:latest

WORKDIR /app

RUN npm install express ejs

COPY . .

RUN npm install

CMD ["node", "app.js"]
