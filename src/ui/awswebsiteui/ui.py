from flask import Flask, jsonify
import awsgi

app = Flask(__name__)


@app.route('/status')
def status():
    return jsonify(status=200, message='OK')


@app.route('/index')
def index():
    return app.send_static_file('./aws-lambda-website/index.html')


def lambda_handler(event, context):
    return awsgi.response(app, event, context, base64_content_types={"image/png"})
