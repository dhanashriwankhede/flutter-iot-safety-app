# 🛡️ Soldier Tent IoT Monitor

A real-time Flutter IoT monitoring app for military tents deployed in extreme environments like Kashmir. It uses Firebase and ESP8266 to track **CO gas**, **temperature**, and **humidity**, ensuring timely alerts for soldiers' safety.

---

## 📱 Features

- 🔄 **Live Sensor Monitoring**
  - Displays real-time readings from:
    - CO Gas Sensor (MQ2)
    - Temperature & Humidity Sensor (DHT22)

- 📊 **Graph Visualization**
  - Line charts showing sensor trends over time
  - Built using `syncfusion_flutter_charts`

- 🚨 **Alert System**
  - Firebase-based real-time gas hazard alerts
  - Displays popup warnings in app

- 🌿 **Clean UI with Light Green Theme**
  - Aesthetic interface for quick monitoring
  - Simple navigation with dedicated pages

---

## 🔧 Technologies Used

| Component              | Details                              |
|------------------------|--------------------------------------|
| Framework              | Flutter 3.24.5                       |
| Dart SDK               | >=2.18.0 <3.0.0                      |
| Backend                | Firebase Realtime Database           |
| Graph Library          | Syncfusion Flutter Charts (v22.1.39)|
| Sensors                | MQ2 (CO Gas), DHT22 (Temp/Humidity) |
| Microcontroller        | ESP8266 (NodeMCU)                    |
| IDE                    | Android Studio Ladybug               |

---

## 🏗️ System Architecture

```

\[MQ2]         \[DHT22]
\|              |
+--> \[ESP8266 / NodeMCU] --> \[Firebase Realtime DB] --> \[Flutter App]


## 📷 Screenshots 
![WhatsApp Image 2025-04-24 at 07 53 42 (1)](https://github.com/user-attachments/assets/876abb53-6cd2-4063-a979-9d181ca787fa)

![WhatsApp Image 2025-04-24 at 07 53 43 (2)](https://github.com/user-attachments/assets/f50caac9-5c35-4c3c-94cb-0fce27d52b0a)

---![WhatsApp Image 2025-04-24 at 07 53 43 (1)](https://github.com/user-attachments/assets/1c93875e-ad63-4bd3-ac39-96d85ae6b058)
![WhatsApp Image 2025-04-24 at 07 53 43](https://github.com/user-attachments/assets/fbfaa3ad-0ea9-4fa1-a1a4-11b699654b44)
![WhatsApp Image 2025-04-24 at 07 53 42](https://github.com/user-attachments/assets/0b7319a2-84fe-472d-875a-2e2cee478797)


## 🔒 Security Notes

* This app avoids committing sensitive Firebase credentials by using `.gitignore`.
* Ensure the Firebase Database has secure read/write rules for production.

---

## 🧪 Status

✅ Working prototype for academic and demo purposes.
🔧 Future improvements may include local data caching, enhanced graph filtering, and secure production Firebase rules.


