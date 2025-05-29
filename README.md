
# FHIR Seek

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![ZPM](https://img.shields.io/badge/ZPM-Compatible-blue)](#)
[![FHIR Version](https://img.shields.io/badge/FHIR-R4-orange)](https://www.hl7.org/fhir/)

**FHIR Seek** is a lightweight, CSP-based web application that enables seamless integration between external FHIR servers (e.g., HAPI) and InterSystems IRIS FHIR servers. It allows users to establish connections, browse, and manage FHIR resources through an intuitive UI.

---

## 🚀 What is FHIR?

**FHIR (Fast Healthcare Interoperability Resources)** is a standard by HL7 for electronically exchanging healthcare information. It defines data formats and APIs for health data exchange.
🔗 [Learn more on HL7.org →](https://www.hl7.org/fhir/overview.html)

---

## 🔍 Why FHIR Seek?

FHIR Seek centralizes the management of multiple FHIR servers, making it easier to:

* Connect to both internal and external FHIR servers
* Retrieve and view all supported FHIR resources in one place
* Search and explore resource data visually

---

## 🛠️ Deployment Options

### Option 1: Deploy via InterSystems Package Manager (ZPM)

```objectscript
zpm "install fhirseek"
```

> This command installs FHIR Seek and all dependencies directly into your IRIS environment.

### Option 2: Manual Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/your-org/fhirseek.git
   ```
2. Import the InterSystems classes into your IRIS environment.
3. Compile and run the application via the CSP gateway.

---

## 🖥️ User Interface Overview

### 🏠 Home Screen

After login, you'll land on the **Home** screen. Here, you can:

* View the default InterSystems IRIS FHIR server
* Add and manage external FHIR servers

![image](https://github.com/user-attachments/assets/e03b905f-2e87-4d7a-9e53-52554c5b7a1a)


---

### ➕ Add or Edit a Server

To add/edit an external FHIR server:

* Fill in the **server name**, **host**, **port**, and **base URL**
* Click **"Add Server"** to save it

![image](https://github.com/user-attachments/assets/f8d1aaa7-d1c2-4721-8f14-9fd5a975b07a)


---

### 🔗 Connect to a Server

To establish a connection:

* Click the **Connect** button next to the desired server
* The app will retrieve and display available FHIR resources


---

### 🔎 Search Resources

Use the built-in search bar to filter FHIR resources by name.
![image](https://github.com/user-attachments/assets/079e4e89-535d-4bb5-911b-df772138b571)

![image](https://github.com/user-attachments/assets/8c5de58a-d366-464e-9e52-68ca582f0c72)


---

## 📦 Example Resources Displayed

* `Patient`
* `Account`
* *More resources are auto-loaded based on your server's support*

 ![image](https://github.com/user-attachments/assets/db7e537f-c8d5-47c6-9691-d24463637aa8)


Account
 
![image](https://github.com/user-attachments/assets/94655569-e0c0-4777-ac7a-e97b3c3ba038)

---

## 📄 License

This project is licensed under the MIT License.
See the [LICENSE](LICENSE) file for details.

---

## 🙌 Contributions

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request. For major changes, open an issue first to discuss what you’d like to change.

---
📬 Feedback & Support
Have a feature request, bug report, or question?
Open an issue or start a discussion.
