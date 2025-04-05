# 📡 Processing-Data-from-Light-Sensors

## 📌 Project Overview

This project is a real-time embedded system designed to process data from a physical sensor using a microcontroller (Arduino Uno) and an FPGA board (Basys3). The system focuses on integrating software and hardware components to enable continuous data monitoring and processing.

The aim of this project is to demonstrate how an FPGA can be used to offload and accelerate data processing tasks normally performed in software. By using VHDL and the AXI Stream protocol, a custom hardware pipeline was created to efficiently handle incoming data and generate useful output.

## 🧠 How the System Works

The architecture is split into two main components. The Arduino acts as a data acquisition module, reading, formatting and sending the data. The Basys3 FPGA serves as the processing unit. The two communicate through the PMod port of the FPGA. The value is then passed through a series of processing modules, including filters, converters, and aggregators. Finally, the processed value is converted and displayed on the board’s 7-segment displays. This update cycle repeats every 30 seconds, in sync with the sensor reading schedule from the Arduino.

![diagrama](https://github.com/user-attachments/assets/372e6e1a-e7bf-4ef2-bcce-5bb2891fc7f4)

![montaj](https://github.com/user-attachments/assets/40ef5110-8714-4887-bce6-013d30c98ef0)

## 🔧 Technologies and Tools

The system is implemented in VHDL and synthesized using Xilinx Vivado for deployment to the Basys3 FPGA board. The Arduino is programmed using C++ and the Arduino IDE. Internally, the FPGA design uses the AXI Stream protocol to connect processing modules in a clean and scalable way. The output interface includes a 7-segment controller capable of displaying numeric results in real time.

