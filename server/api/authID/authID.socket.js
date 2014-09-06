/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Authid = require('./authID.model');

exports.register = function(socket) {
  Authid.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Authid.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('authID:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('authID:remove', doc);
}