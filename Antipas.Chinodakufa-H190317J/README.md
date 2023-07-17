# Autonomous Parking Bay

# Project Description
Autonomous parking bay is a parking system that allows for the collection of parking fees, payment of parking fees and monitoring of parking bays without the need of human input. The current system is human intensive, it requires human input in parking duration measurement, payment, identification and reporting. This system leads to errors, miscalculations and corruption at all parking bays. The proposed system takes the human out of the equation and replaces with computer vision powered by licence plate recognition AI models as well as an integrated payment and reporting system. The robust system will collect fees hence also handle payment of parking fees through an online payment system. Furthermore, it measures duration of parking vehicles and calculate parking costs accrued. The system generates reports that allow with the management of the system at large. 
3.2.1 Step-wise description of proposed system 
    *	The driver parks in the parking bay.
    *	The Detection System scans the number plate using a camera and starts a timer.
    *	The Detection System queries the Database for the customer account associated with the number plate.
    *	The driver leaves the parking bay.
    *	The Detection System stops the timer and calculates the parking cost based on the duration.
    *	The Database updates the customer account with the parking cost and records the car service and fee information.
    *	The driver logs in to the Payment System using the number plate as an identifier.
    *	The Payment System retrieves the transaction history from the Database for the customer account.
    *	The driver pays for the parking using PayNow, a third party payment platform that is integrated with the Payment System.
    *	The Payment System confirms the payment and updates the payment status in the Database.
    *	The Reporting System retrieves the car service and fee information from the Database and generates a report of the parking activity.
    *	The Reporting System displays the report to a dashboard for monitoring and analysis.

# Installation
To install this project, you need to have Python 3.8 or higher, and pip installed on your system. You also need to have a PostgreSQL database server running on your machine.

Follow these steps to install this project:

1. Clone this repository to your local machine: `git clone https://github.com/antipasic/APB.git`
2. Navigate to the project folder: `cd APB`

for PARKPAY and APB DASHBOARD
3. Create a virtual environment: `python -m venv env`
4. Activate the virtual environment: `source env/bin/activate` (Linux/Mac) or `env\Scripts\activate` (Windows)
5. Install the required packages: `pip install -r requirements.txt`
6. Create a .env file in the project folder, and add the following variables:

    - SECRET_KEY: A secret key for Django's security features. You can generate one using this tool: https://djecrety.ir/
    - DEBUG: A boolean value that indicates whether to run the app in debug mode or not. Set it to True for development, and False for production.
    - DATABASE_URL: A URL that specifies the connection details for your PostgreSQL database. The format is: postgresql://user:password@host:port/database

7. Run the database migrations: `python manage.py migrate`
8. Create a superuser account: `python manage.py createsuperuser`
9. Run the development server: `python manage.py runserver`

You should now be able to access the app at http://localhost:8000/

for DETECTION SYSTEM
10. Navigate to program folder : `cd "project 3"`
11. Create a virtual environment : `python -m venv env`
12. Activate the virtual environment: `source env/bin/activate` (Linux/Mac) or `env\Scripts\activate` (Windows)
13. Install the required packages: `pip install -r requirements.txt`
14. run the python file : `python Project3.py`

# Usage
To use this app, you need to register an account or log in with the superuser account. Once logged in, you can 

# Tests
To run tests for this project, you need to have pytest and pytest-django installed on your virtual environment. You can install them by running: `pip install pytest pytest-django`

To run the tests, navigate to the project folder and run: `pytest`

The tests will cover the models, views, forms, and templates of the app. They will also check the code quality and style using flake8 and black.

To report any bugs or issues, please use the project's issue tracker: https://github.com/antipasic/APB/issues

# Contributing
No contributions allowed yet!
