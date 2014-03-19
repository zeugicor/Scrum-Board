var options = require('optimist')
  .alias('e', 'env')
  .alias('p', 'port')
  .arvg;

// if (options.env)
//     process.env.NODE_ENV = options.env;
// if (options.port)
//     process.env.PORT = options.port;

require('coffee-script/register');
require('./app/app');