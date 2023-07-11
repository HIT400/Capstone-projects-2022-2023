# Disease Identification using ZEDD Stereo Camera Dual Vision

## Overview

This codebase uses Keras, TensorFlow, and PyTorch to scan a video feed from the ZEDD stereo camera dual vision and identify diseases.

## Installation

### On Linux PC

1. Create a virtual environment in the code folder: `virtualenv env` or `python3 -m venv env`
2. Activate the virtual environment: `source env/bin/activate`
3. Install the required packages: `pip3 install -r requirements/requirements.txt`
4. Run the code: `python3 sharingan.py`

### On Jetson



# Disease Identification using ZEDD Stereo Camera Dual Vision

## Overview

This codebase uses Keras, TensorFlow, and PyTorch to scan a video feed from the ZEDD stereo camera dual vision and identify diseases.

## Installation

### On Linux PC

1. Create a virtual environment in the code folder: `virtualenv env` or `python3 -m venv env`
2. Activate the virtual environment: `source env/bin/activate`
3. Install the required packages: `pip3 install -r requirements/requirements.txt`
4. Run the code: `python3 sharingan.py`

### On Jetson

1. Do not create a virtual environment as it will cause core dumps. Instead, just install Python3.
2. Install the required packages: `pip3 install -r requirements/requirements_jetson.txt`

## Usage

### Training a Neural Network

1. Create folders with names like categories.json
2. Insert the correct pictures in the folders
3. Run `train.py` or `tomato-leaf-disease-classification.ipynb` (after populating labeled data as in the notebook)

For help with the notebook, visit https://github.com/divyansh1195/Tomato-Leaf-Disease-Detection-.git to train data for use with ZEDD.

### Testing the Trained Model

To test the trained model, load the Keras model into the Flask app in line 37
Run pip3 -r install requirements/requirements_app.txt , then start the Flask app to use test pictures by uploading and evaluating results.



