winston = require 'winston' 

module.exports = (robot) ->
  logger = new winston.Logger {
        transports: [
              new winston.transports.Console(),
              new (winston.transports.File)({ filename: 'somefile.log' })
            ]
      });


