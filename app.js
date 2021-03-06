const express = require('express');
const path = require('path');
const cors = require('cors');
const logger = require('morgan');
const bearerToken = require('express-bearer-token');
const { Expo } = require("expo-server-sdk");
const expo = new Expo();

require('dotenv').config();
require('./config/database');

const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');
const parentsRouter = require('./routes/parents');
const childrenRouter = require('./routes/children');
const locationRouter = require('./routes/location');
const geofenceService = require('./routes/geofence');
const trustedContactRouter = require('./routes/contact');
const notificationsRouter = require('./routes/notifications');

const app = express();
const port = process.env.PORT || 3000;

app.use(logger('dev'));
app.use(cors());
app.use(bearerToken());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/parents', parentsRouter);
app.use('/children', childrenRouter);
app.use('/location', locationRouter);
app.use('/geofence', geofenceService);
app.use('/contact', trustedContactRouter);
app.use('/notifications', notificationsRouter);

app.listen(port, () => console.log(`Server listening: http://localhost:${port}`));
module.exports = app;
