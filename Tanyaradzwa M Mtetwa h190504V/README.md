The automated dual boom gate system with number plate recognition and reports production was
implemented using several hardware and software components. The hardware components
included sensors, cameras, an Arduino microcontroller, and a boom gate system. The software
components included online license plate recognizer software API, Python, PHP, and XAMPP.
The first step in the implementation was to install and configure the hardware components,
including the sensors, cameras, and boom gate system. The sensors were installed at the entry
and exit points of the premise to detect the presence of vehicles. The cameras were installed to
capture the license plate images of the vehicles as they approached the gate.
The next step was to integrate the online license plate recognition software API with the system.
The API was used to analyze the license plate images captured by the cameras and to compare
them with a database of authorized vehicles. The license plate recognition software API was
integrated with Python, which was used to access the API and handle the data.
The Arduino microcontroller was used to control the boom gate system. The microcontroller was
programmed to receive signals from the sensors and the license plate recognition software API.
If the vehicle was authorized, the microcontroller would activate the boom gate system and allow
38
the vehicle to enter or exit the premise.Finally, the reporting function was implemented using
PHP and XAMPP. The PHP script was used to extract data from the license plate recognition
software API and store it in a MySQL database. The XAMPP server was used to host the PHP
script and generate reports on vehicle access and activity.