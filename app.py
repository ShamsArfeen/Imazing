from flask import Flask, request, jsonify
import os

app = Flask(__name__)

@app.route("/")
def welcome():
    return "Imazing API"

@app.route("/feature1") # this is how we create endpoints
def feature1():
    return "feature 1"

if __name__ == "__main__":
    app.run()