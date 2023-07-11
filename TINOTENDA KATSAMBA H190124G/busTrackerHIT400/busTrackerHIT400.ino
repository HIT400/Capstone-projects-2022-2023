#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>

TinyGPSPlus gps;
SoftwareSerial ss(D5, D6);
SoftwareSerial SIM900(D7, D8); // gsm module connected here

String postData ; // post array that will be send to the website
String link = "http://192.168.32.99/project/post.php"; //computer IP or the server domain
const char* ssid = "******"; //ssid of your wifi
const char* password = "******"; //password of your wifi

int count = 0;

double SPEED;
float latitude , longitude;
int year , month , date, hour , minute , second;
String date_str , time_str , lat_str , lng_str;
int pm;
String SMS;
String txtmessage;

boolean msgsend= false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  SIM900.begin(9600);
  ss.begin(9600);
  delay(2000);

  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid,password); //connecting to wifi
  while (WiFi.status() != WL_CONNECTED)// while wifi not connected
  {
    delay(500);
    Serial.print("."); //print "...."
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println(WiFi.localIP());  // Print the IP address

  SIM900.println("AT"); //Handshaking with SIM900
  updateSerial();
  SIM900.println("AT+CMGF=1"); // Configuring TEXT mode
  updateSerial();
  SIM900.println("AT+CNMI=1,2,0,0,0"); // Decides how newly arrived SMS messages should be handled
  updateSerial();
}

void loop() {
  // put your main code here, to run repeatedly:
  while (ss.available() > 0) //while data is available
    if (gps.encode(ss.read())) //read gps data
    {
      if (gps.location.isValid()) //check whether gps location is valid
      {
        latitude = gps.location.lat();
        lat_str = String(latitude , 12); // latitude location is stored in a string
        longitude = gps.location.lng();
        lng_str = String(longitude , 12); //longitude location is stored in a string
        SPEED = gps.speed.kmph();

        SMS =  "";
        SMS = SMS + "https://www.google.com/maps/search/?api=1&query=";
        SMS = SMS + lat_str;
        SMS = SMS + ",";
        SMS = SMS + lng_str;
        SMS = SMS + "\n";
        delay(2000);
        handleSerial();

        WiFiClient client;
        HTTPClient http;    //Declare object of class HTTPClient
        //Post Data
        //postData = "lat=837227279972&lng=8338939839298"; // Add the Fingerprint ID to the Post array in order to send it
        // Post methode
        postData = "lat=" + lat_str + "&lng=" + lng_str;
        http.begin(client, link); //initiate HTTP request, put your Website URL or Your Computer IP 
        http.addHeader("Content-Type", "application/x-www-form-urlencoded");    //Specify content-type header
  
        int httpCode = http.POST(postData);   //Send the request
        String payload = http.getString();    //Get the response payload

        if (httpCode > 0) {
          // HTTP header has been send and Server response header has been handled
          Serial.printf("[HTTP] POST... code: %d\n", httpCode);

          // file found at server
          if (httpCode == HTTP_CODE_OK) {
            const String& payload = http.getString();
            Serial.println("received payload:\n<<");
            Serial.println(payload);
            Serial.println(postData);
            Serial.println(">>");
          }
        } else {
          Serial.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpCode).c_str());
        }
        http.end();
      }
    }
}

void sendSMS(String message){
  SIM900.println("AT"); //Handshaking with SIM900
  updateSerial();
  SIM900.println("AT+CMGF=1"); // Configuring TEXT mode
  updateSerial();
  SIM900.println("AT+CMGS=\"+263771720831\"");//change ZZ with country code and xxxxxxxxxxx with phone number to sms
 updateSerial();
  SIM900.print(message); //text content
  updateSerial();
  SIM900.write(26);
  delay(5000);
}

void updateSerial()
{
  delay(500);
  while(SIM900.available())
  {
    Serial.write(SIM900.read());//Forward what Software Serial received to Serial Port
  }
}

void handleSerial()
{ 
    const int BUFF_SIZE = 32; // make it big enough to hold your longest command
    static char buffer[BUFF_SIZE+1]; // +1 allows space for the null terminator
    static int length = 0; // number of characters currently in the buffer
    
    if(SIM900.available())
    {     
        char c = SIM900.read();
        if((c == '\r') || (c == '\n'))
        {
            // end-of-line received
            if(length > 0)
            {
                handleReceivedMessage(buffer);
            }
            length = 0;
        }
        else
        {
            if(length < BUFF_SIZE)
            {
                buffer[length++] = c; // append the received character to the array
                buffer[length] = 0; // append the null terminator
            }
            else
            {
                // buffer full - discard the received character
            }
        }
    }
    else{
        // Serial.println("hapana chauya");
    }
}

void handleReceivedMessage(char *msg)
{
  if(strcmp(msg, "location") == 0) {
    sendSMS(SMS);
    SMS = "";
  }
}
