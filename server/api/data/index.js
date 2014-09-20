'use strict';

var express = require('express');
var controller = require('./data.controller');
var cors = require('cors');
var router = express.Router();

router.get('/:playerName', controller.show);

module.exports = router;