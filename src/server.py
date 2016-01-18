from flask import Flask
from flask_jsonrpc import JSONRPC as rpc

class Server(Flask):
    def get_send_file_max_age(self, name):
        if (name in [ 'jquery-1.12.0.min.js', 'jquery-migrate-1.2.1.min.js', 'jquery.jsonrpcclient.js']):
            return 100000

        return 0

app = Server(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.getData")
def getData():
    return {
        'variables': ['n', 'k', 'j'],
        'data': [
            [7, 9, 0],
            [7, 8, 1],
            [7, 7, 2],
            [7, 6, 3],
            [7, 5, 4],
            [7, 4, 5],
            [7, 3, 6],
            [7, 2, 7],
        ]
    }

if __name__ == "__main__":
    app.run()
