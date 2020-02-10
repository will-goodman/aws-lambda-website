from flask import Flask, jsonify
import awsgi

app = Flask(__name__)


@app.route('/api/status')
def index():
    return jsonify(status=200, message='OK')


def lambda_handler(event, context):
    return awsgi.response(app, event, context, base64_content_types={"image/png"})
