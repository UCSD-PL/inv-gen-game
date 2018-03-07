var connect = require('connect'),
    http = require('http');
var port = process.env.port || 1337;
connect()
    .use(connect.static("/pages"))
    .use(connect.directory("/pages/tutorial.html"))
//http.createServer(function (req, res) {
//    res.writeHead(200, { 'Content-Type': 'text/plain' });
//    res.end('Hello World\n');
//})
    .listen(port);