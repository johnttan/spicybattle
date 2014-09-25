'use strict';

var express = require('express');
var controller = require('./statistics.controller');

var router = express.Router();

router.get('/:id', controller.show);


module.exports = router;