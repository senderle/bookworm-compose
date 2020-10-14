from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello World!"

@app.route('/cgi-bin')
def hello_cgi():
    return "Hello Cgi-Bin!"

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port="10013")
