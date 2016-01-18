from flask import Flask
from flask_jsonrpc import JSONRPC as rpc
app = Flask(__name__, static_folder='static/', static_url_path='')
api = rpc(app, '/api')

@api.method("App.test")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()
