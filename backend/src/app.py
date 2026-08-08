from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)

CORS(app)


@app.route("/")
def home():
    return jsonify({
        "service": "backend",
        "message": "Backend service is running"
    })


@app.route("/health")
def health():
    return jsonify({
        "service": "backend",
        "status": "healthy"
    })


@app.route("/api/message")
def message():
    return jsonify({
        "message": "Hello from Python backend"
    })


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )