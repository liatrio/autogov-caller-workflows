from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Bye World'

@app.route('/health')
def health():
    return 'OK', 200

if __name__ == '__main__':
    app.run(debug=True)
