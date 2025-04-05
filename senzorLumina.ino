int photoPin=A0;
int outPins[8] = {2, 3, 4, 5, 6, 7, 8, 9};
int sensorValue=0;
int digits[8];

void setup() {
  Serial.begin(9600);
  pinMode(photoPin,INPUT);
  for (int i = 0; i < 8; i++)
    pinMode(outPins[i], OUTPUT);
}

void loop() {
  sensorValue=analogRead(photoPin);
  int mappedValue = map(sensorValue, 0, 1023, 0, 255);

  Serial.print("Sensor Value: ");
  Serial.println(sensorValue);
  Serial.print("Mapped Value: ");
  Serial.println(mappedValue);

  writeToPmod(mappedValue);

  delay(10000);
}

void writeToPmod(int value) {
    Serial.print("Binary Value: ");
    for (int i = 0; i < 8; i++)
    {
      int bit = (value >> i) & 1; 
      digitalWrite(outPins[i], bit);
      Serial.print(bit);
    }
    Serial.println();
}



