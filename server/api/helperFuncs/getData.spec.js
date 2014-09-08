var should = require('should');
var getData = require('./getData.js')
describe('validation', function(){
    var validJSON = {
        data: {
            profile: {
                playerName: 'test'
            }
        }
    };
    var invalidJSON = {
        data: {}
    };
    it('should return true on valid data', function(){
        getData.verify(validJSON, 'test').should.be.ok
    });
    it('should return false on valid data', function(){
        getData.verify(invalidJSON, 'lol').should.not.be.ok
    });
})