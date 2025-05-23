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



---

## 🔒 Security Notes

* This app avoids committing sensitive Firebase credentials by using `.gitignore`.
* Ensure the Firebase Database has secure read/write rules for production.

---

## 🧪 Status

✅ Working prototype for academic and demo purposes.
🔧 Future improvements may include local data caching, enhanced graph filtering, and secure production Firebase rules.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

