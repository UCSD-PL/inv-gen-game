from flask import Flask
from flask_jsonrpc import JSONRPC as rpc

traces = {
    '15-c': {
        'variables': ['n', 'k', 'j'],
        'data': [
            [7, 9, 0],
            [7, 8, 1],
            [7, 7, 2],
            [7, 6, 3],
            [7, 5, 4],
            [7, 4, 5],
            [7, 3, 6],
            [7, 2, 7]
        ]
    },

    '19-c': {
        'variables': ['n', 'm', 'x', 'y'],
        'data': [
            [7, 3, 0, 3],
            [7, 3, 1, 3],
            [7, 3, 2, 3],
            [7, 3, 3, 3],
            [7, 3, 4, 4],
            [7, 3, 5, 5],
            [7, 3, 6, 6],
        ]
    },

    '25-c outer loop': {
        'variables': ['x', 'y', 'i', 'j'],
        'data': [
            [0, 0, 0, 0],
            [1, 1, 4, 0],
            [2, 2, 8, 0],
            [3, 3, 12, 0],
        ]
    },

    '25-c inner loop': {
        'variables': ['x', 'y', 'i', 'j'],
        'data': [
            [0, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 2, 0],
            [0, 0, 3, 0],
            [1, 1, 4, 0],
            [1, 1, 5, 0],
            [1, 1, 6, 0],
            [1, 1, 7, 0],
            [2, 2, 8, 0],
            [2, 2, 9, 0],
            [2, 2, 10, 0],
            [2, 2, 11, 0],
            [3, 3, 12, 0],
            [3, 3, 13, 0],
            [3, 3, 14, 0],
            [3, 3, 15, 0],
        ]
    },
}

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', 'jquery-migrate-1.2.1.min.js', 'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.listData")
def listData():
    return traces.keys()

@api.method("App.getData")
def getData(traceId):
    if (traceId not in traces):
        raise Exception("Unkonwn trace " + traceId)

    return traces[traceId]

if __name__ == "__main__":
    app.run()
