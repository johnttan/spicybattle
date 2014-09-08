'use strict';

var express = require('express');
var controller = require('./data.controller');
var cors = require('cors')
var router = express.Router();

router.get('/', controller.index);
router.get('/:playerName', controller.show);
// router.post('/', cors(), controller.create);
router.put('/:playerName', controller.update);
// router.patch('/:id', controller.update);
// router.delete('/:id', controller.destroy);

module.exports = router;