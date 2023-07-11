import pyzed.sl as sl
import cv2
import numpy as np

def main():
    # Create a Camera object
    zed = sl.Camera()

    # Create a InitParameters object and set configuration parameters
    init_params = sl.InitParameters()
    init_params.camera_resolution = sl.RESOLUTION.HD2K  # Use HD2K video mode for higher quality images
    init_params.camera_fps = 15  # Set fps at 60

    # Open the camera
    err = zed.open(init_params)
    if err != sl.ERROR_CODE.SUCCESS:
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
            combined_image = np.hstack((image_left.get_data(), image_right.get_data()))
            # Resize combined image to fit screen
            #combined_image = cv2.resize(combined_image, (screen_width, int(screen_width * combined_image.shape[0] / combined_image.shape[1])))
            # Display combined image with OpenCV
            cv2.imshow("ZED", combined_image)
            key = cv2.waitKey(1)

    # Close the camera
    zed.close()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()