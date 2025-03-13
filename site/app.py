from flask import Flask, jsonify, request, render_template

app = Flask(__name__)

@app.route('/')
def index():
  render_template('index.html')

@app.route('/album')
def album():
  render_template('album.html')


