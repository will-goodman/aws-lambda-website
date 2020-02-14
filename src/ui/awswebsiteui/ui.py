from flask import Flask, jsonify, send_from_directory
import awsgi

app = Flask(__name__)


@app.route('/status')
def status():
    return jsonify(status=200, message='OK')


@app.route('/')
def index():
    return app.send_static_file('./aws-lambda-website/index.html')


@app.route('/dist/<path:path>')
def dist(path):
    return send_from_directory('dist', path)


def lambda_handler(event, context):
    return awsgi.response(app, event, context, base64_content_types={"image/png"})
