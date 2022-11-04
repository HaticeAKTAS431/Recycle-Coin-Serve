const express = require('express');
const app = express();
const routers = require('./routers');

app.get('/', function (req, res) {
  res.json('FI Serve Project');
});

app.use((req, res, next) => {
  res.send('404 NOT FOUND');
});

module.exports = app;
