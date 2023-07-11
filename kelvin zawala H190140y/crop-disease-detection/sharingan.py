from __future__ import division, print_function
# coding=utf-8
import numpy as np
import pyzed.sl as sl
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

from PIL import Image
#import matplotlib.pyplot as plt
import cv2



#from train import Model as plantmodel

class ObjectDetection:
    """
    The class performs generic object detection on a video file.
    It uses yolo5 pretrained model to make inferences and opencv2 to manage frames.
    Included Features:
    1. Reading and writing of video file using  Opencv2
    2. Using pretrained model to make inferences on frames.
    3. Use the inferences to plot boxes on objects along with labels.
    Upcoming Features:
    """
    def __init__(self):
        """
        :param input_file: provide youtube url which will act as input for the model.
        :param out_file: name of a existing file, or a new file in which to write the output.
        :return: void
        """
        self.model = self.load_model('model_inception.h5')

        #self.model.conf = 0.4 # set inference threshold at 0.3
        #self.model.iou = 0.3 # set inference IOU threshold at 0.3
        #self.model.classes = [0] # set model to only detect "Person" class

    def load_model(self, filepath):
        model = load_model(filepath)
        return model
    
    def score_frame(self, frame):
        """
        function scores each frame of the video and returns results.
        :param frame: frame to be infered.
        :return: labels and coordinates of objects found.

        """
        pil_image = Image.fromarray(frame).convert('RGB')
        image_np = np.array([self.process_image(pil_image)])

        x=image_np
        preds = self.model.predict(x)
        preds=np.argmax(preds, axis=1)
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
        elif preds==9:
            preds="None"
        else:
            preds='background'
        
    
    
        return preds
    
    def draw_predictions(self):
        # Create a Camera object
        zed = sl.Camera()

        # Create a InitParameters object and set configuration parameters
        init_params = sl.InitParameters()
        init_params.camera_resolution = sl.RESOLUTION.HD2K  # Use HD2K video mode for higher quality images
        init_params.camera_fps = 60  # Set fps at 60

        # Open the camera
        err = zed.open(init_params)
        if err != sl.ERROR_CODE.SUCCESS:
            print(err)
            exit(1)
            

        

        # Create Mat objects for left and right images
        image_left = sl.Mat()
        image_right = sl.Mat()

    # Get screen size
        cv2.namedWindow("ZED", cv2.WND_PROP_FULLSCREEN)
        cv2.setWindowProperty("ZED", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
        screen_width = cv2.getWindowImageRect("ZED")[2]



    # Capture new images until 'q' is pressed
        key = ''
        while key != ord('q'):
                # Grab an image
            if zed.grab() == sl.ERROR_CODE.SUCCESS:
                # Retrieve left and right images
                zed.retrieve_image(image_left, sl.VIEW.LEFT)
                zed.retrieve_image(image_right, sl.VIEW.RIGHT)
                
                # Combine left and right images horizontally
                combined_image = np.hstack((self.label_frame(image_left.get_data()), self.label_frame(image_right.get_data())))
                # Resize combined image to fit screen
                #combined_image = cv2.resize(combined_image, (screen_width, int(screen_width * combined_image.shape[0] / combined_image.shape[1])))
                # Display combined image with OpenCV
                cv2.imshow("ZED", combined_image)
                key = cv2.waitKey(1)
            
        # Close the camera and destroy window
        zed.close()
        cv2.destroyAllWindows()

    def label_frame(self,frame):
        
        # Preprocess the frame for AI inference

         # Perform AI inference on the frame
        
            prediction = self.score_frame(frame)

        # Draw boxes on regions of interest with some text
            frame=self.square_img(frame)
            frame_height, frame_width = frame.shape[:2]
            rect_width, rect_height = 600, 600

            x1 = (frame_width - rect_width) // 2
            y1 = (frame_height - rect_height) // 2
            x2 = x1 + rect_width
            y2 = y1 + rect_height

            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.putText(frame, f'{prediction}', (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1.4, (0, 255, 0), 8)

           # Display the resulting frame
            return frame
    
    def square_img(self,image):
        # Get the dimensions of the image
        height, width = image.shape[:2]

        # Calculate the coordinates of the square region to crop
        min_dim = min(width, height)
        left = (width - min_dim) // 2
        top = (height - min_dim) // 2
        right = (width + min_dim) // 2
        bottom = (height + min_dim) // 2

        # Crop the image to the square region
        cropped_image = image[top:bottom, left:right]
        return cropped_image

    def process_image(self, image):
        #width, height = image.size
        #min_dim = min(width, height)
        #left = (width - min_dim) // 2
        #top = (height - min_dim) // 2
        #right = (width + min_dim) // 2
        #bottom = (height + min_dim) // 2
        #image = image.crop((left, top, right, bottom))
        size = 256, 256
        image.thumbnail(size, Image.Resampling.LANCZOS)
        image = image.crop((128 - 112, 128 - 112, 128 + 112, 128 + 112))
        npImage = np.array(image)
        npImage = npImage/255.
        
        imgA = npImage[:,:,0]
        imgB = npImage[:,:,1]
        imgC = npImage[:,:,2]
    
        imgA = (imgA - 0.485)/(0.229) 
        imgB = (imgB - 0.456)/(0.224)
        imgC = (imgC - 0.406)/(0.225)
        
        npImage[:,:,0] = imgA
        npImage[:,:,1] = imgB
        npImage[:,:,2] = imgC
    
        #npImage = np.transpose(npImage, (2,0,1))
    
        return npImage
    

    #def imshow(self, image, ax=None, title=None):
        #if ax is None:
       #     fig, ax = plt.subplots()
    
    # PyTorch tensors assume the color channel is the first dimension
    # but matplotlib assumes is the third dimension
      #  image = image.numpy().transpose((1, 2, 0))
    
    # Undo preprocessing
     #   mean = np.array([0.485, 0.456, 0.406])
    #    std = np.array([0.229, 0.224, 0.225])
   #     image = std * image + mean
    
    # Image needs to be clipped between 0 and 1 or it looks like noise when displayed
  #      image = np.clip(image, 0, 1)
    
 #       ax.imshow(image)
    
 #       return ax
    
    
    def __call__(self):
       self.draw_predictions()


a = ObjectDetection()
a()