#=============================#
#common imports               #
#=============================#
#import pyzed.sl as sl
from collections import OrderedDict
from PIL import Image, ImageDraw, ImageFont
#from datetime import datetime
from torch.autograd import Variable
import time
#from PIL import Image
from torch.optim import lr_scheduler
#import matplotlib.pyplot as plt
import copy
#import cv2
#import pyzed.sl as sl
import numpy as np
#import math
#import gradio as gr
# use this only on google colab
#from google.colab import files 
#from glob import glob
import os

#=============================#
#pytorch imports              #
#=============================#
import torch
import torch.nn as nn
#import torch.nn.functional as F
import torch.optim as optim
#import torch.utils.data as data
import torchvision
from torchvision import models, datasets, transforms
from torchvision.models import ResNet18_Weights


#=============================#
#pytorch-lightning imports    #
#=============================#

#import pytorch_lightning as pl
#import torchmetrics as tm
#from pytorch_lightning.callbacks import ModelCheckpoint, EarlyStopping, LearningRateMonitor, Callback