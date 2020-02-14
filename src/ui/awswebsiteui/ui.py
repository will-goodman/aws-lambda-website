from flask import Flask, jsonify, send_from_directory
from alb_response import alb_response
import awsgi

app = Flask(__name__)


@app.route('/status')
def status():
    return jsonify(status=200, message='OK')


@app.route('/index')
def index():
    print("index")
    return app.send_static_file('./aws-lambda-website/index.html')


@app.route('/dist/<path:path>')
def dist(path):
    print(path)
    return send_from_directory('./aws-lambda-website/dist', path)


def lambda_handler(event, context):
    response = awsgi.response(app, event, context, base64_content_types={"image/png"})

    print(response)

    return response
