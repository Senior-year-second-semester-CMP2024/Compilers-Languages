from flask import Flask
from flask_cors import CORS

# Create Flask app instance
app = Flask(__name__, static_url_path="/static")
CORS(app)

# Import routes after creating app instance to avoid circular imports
from app import routes
