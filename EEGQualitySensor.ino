#include <SoftwareSerial.h>
#include <BH1750.h>
#include <Wire.h>
#include <DHT.h>

// Khai báo
SoftwareSerial Bluetooth(10, 11); // RX, TX

#define CO2sensor A0
#define SoundSensor A2
#define DHTPIN 7  // Chân nối DHT11
#define DHTTYPE DHT11  // Loại cảm biến DHT

BH1750 lightMeter;
DHT dht(DHTPIN, DHTTYPE);

const int sampleWindow = 50;
unsigned int sample;
const float micSensitivity = -46.0;
const float refVoltage = 0.005012;
const float SPL_1Pa = 94.0;
const float preampGain = 25.0;

void setup() {
  // Khởi tạo 
  pinMode(CO2sensor, INPUT);
  pinMode(SoundSensor, INPUT);
  Serial.begin(9600);           
  Bluetooth.begin(38400);       
  Wire.begin();
  lightMeter.begin();
  dht.begin(); 
}

void loop() {
  // Đọc data từ MQ135
  int gas = analogRead(CO2sensor);
  int co2lvl = map(gas, 0, 1024, 400, 5000);

  // Đọc dữ liệu từ BH1750
  float lux = lightMeter.readLightLevel();

  // Đọc dữ liệu từ MAX4466
  int rawValue = analogRead(SoundSensor);
  float voltage = rawValue * (5.0 / 1023.0);
  float dbVoltage = 20.0 * log10(voltage / refVoltage);
  float db = micSensitivity + dbVoltage + SPL_1Pa - preampGain;

  // Đọc dữ liệu từ cảm biến DHT11
  float temperature = dht.readTemperature(); // Đọc nhiệt độ
  float humidity = dht.readHumidity();       // Đọc độ ẩm

  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // In giá trị ra Serial Monitor
  Serial.print("CO2 Concentration: ");
  Serial.print(co2lvl);
  Serial.println(" ppm");

  Serial.print("Light Intensity: ");
  Serial.print(lux);
  Serial.println(" lux");

  Serial.print("Sound Level: ");
  Serial.print(db);
  Serial.println(" dB");

  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.println(" °C");

  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.println(" %");

  // Gửi dữ liệu dạng JSON
  String data = "{";
  data += "\"CO2Concentration\": " + String(co2lvl) + ",";
  data += "\"lightIntensity\": " + String(lux) + ",";
  data += "\"soundLevel\": " + String(db) + ",";
  data += "\"temperature\": " + String(temperature) + ",";
  data += "\"humidity\" :" + String(humidity);
  data += "}";

  Bluetooth.println(data);

  delay(1000); // Chờ 1000ms trước khi đọc lại
}
