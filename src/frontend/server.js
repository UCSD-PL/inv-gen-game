define(["require", "exports", "http"], function (require, exports, http) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var port = process.env.port || 1337;
    http.createServer(function (req, res) {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Hello World\n');
    }).listen(port);
});
//# sourceMappingURL=server.js.map