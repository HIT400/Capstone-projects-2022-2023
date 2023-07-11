# -*- coding: utf-8 -*-
"""
Created by Divyansh Mathur
"""

from __future__ import division, print_function
# coding=utf-8
import sys
import os
import glob
import re
import cv2
import numpy as np
import tensorflow as tf

from tensorflow.compat.v1 import ConfigProto
from tensorflow.compat.v1 import InteractiveSession

config = ConfigProto()
config.gpu_options.per_process_gpu_memory_fraction = 0.5
config.gpu_options.allow_growth = True
session = InteractiveSession(config=config)
# Keras
from tensorflow.keras.applications.resnet50 import preprocess_input
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image

# Flask utils
from flask import Flask, redirect, url_for, request, render_template
from werkzeug.utils import secure_filename
#from gevent.pywsgi import WSGIServer

# Define a flask app
app = Flask(__name__)

# Model saved with Keras model.save()
MODEL_PATH ='model_inception.h5'

# Load your trained model
model = load_model(MODEL_PATH)




def model_predict(img_path, model):
    print(img_path)
    img = image.load_img(img_path)

    # Crop the image to a square shape if necessary
    width, height = img.size
    if width != height:
        min_dim = min(width, height)
        left = (width - min_dim) // 2
        top = (height - min_dim) // 2
        right = (width + min_dim) // 2
        bottom = (height + min_dim) // 2
        img = img.crop((left, top, right, bottom))
    
    # Resize the image to the target size
    img = img.resize((224, 224))
    x = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2YCrCb)
    x = cv2.resize(x, (224, 224))
    x = np.expand_dims(x, axis=0)
    x[..., 0] = x[..., 0] - 128.0
    x[..., 1:] = x[..., 1:] - 128.0
    x = x.astype('float32')
   
    # x = np.true_divide(x, 255)
    ## Scaling
    x=x/255
   

    # Be careful how your trained model deals with the input
    # otherwise, it won't make correct prediction!
   # x = preprocess_input(x)
    print(type(x))
    preds = model.predict(x)
    preds=np.argmax(preds, axis=1)
    print(preds)
    if preds==0:
        preds="Bacterial_spot"
    elif preds==1:
        preds="Early_blight"
    elif preds==2:
        preds="Late_blight"
    elif preds==3:
        preds="Leaf_Mold"
    elif preds==4:
        preds="Septoria_leaf_spot"
    elif preds==5:
        preds="Spider_mites Two-spotted_spider_mite"
    elif preds==6:
        preds="Target_Spot"
    elif preds==7:
        preds="Tomato_Yellow_Leaf_Curl_Virus"
    elif preds==8:
        preds="Tomato_mosaic_virus"
    else:
        preds="Healthy"
        
    
    
    return preds


@app.route('/', methods=['GET'])
def index():
    # Main page
    return render_template('index.html')


@app.route('/predict', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        # Get the file from post request
        f = request.files['file']

        # Save the file to ./uploads
        basepath = os.path.dirname(__file__)
        file_path = os.path.join(
            basepath, 'uploads', secure_filename(f.filename))
        f.save(file_path)

        # Make prediction
        preds = model_predict(file_path, model)
        result=preds
        return result
    return None


if __name__ == '__main__':
    app.run(port=5001,debug=True)
