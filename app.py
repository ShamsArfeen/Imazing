from flask import Flask, request, jsonify
import os
from utils import *

app = Flask(__name__)

@app.route("/")
def welcome():
    return "Imazing API"

@app.route("/compact_image")
def compact_image():
    '''Compresses image based on the compression ratio'''
    return _compact_image()

@app.route("/adjust_saturation")
def adjust_saturation():
    '''Adjusts saturation level of the image'''
    return _adjust_saturation()

@app.route("/mirror")
def mirror():
    '''Mirrors image about the x or y axis'''
    return _mirror()

@app.route("/smoothen")
def smoothen():
    '''Smooths the image (blurs the sharp features)'''
    return _smoothen()

@app.route("/rotate")
def rotate():
    '''Rotates the image according to the degrees specified'''
    return _rotate()

@app.route("/rgb_alteration")
def alter_rgb():
    '''Changes the rgb intensities of the image'''
    return _alter_rgb()

@app.route("/sharpen")
def sharpen():
    '''Sharpens the image to bring out more detail'''
    return _sharpen()

if __name__ == "__main__":
    app.run()