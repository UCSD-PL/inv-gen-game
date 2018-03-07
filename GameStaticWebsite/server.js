var connect = require('connect'), http = require('http');
var port = process.env.port || 1337;
connect()
    .use(connect.static("/pages"))
    .use(connect.directory("/pages/tutorial.html"))
    .listen(port);
//# sourceMappingURL=server.js.map