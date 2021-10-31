# UIDAI-hackathon-Problem-Statement-2

We are a team of 5, B.Tech 2nd year students, we developed did project for [AADHAAR HACKATHON 2021](https://hackathon.uidai.gov.in/).
### Team reference: OHF3QUSj1f
### Theme 1: Address Update <br> [Problem Statement 2](https://hackathon.uidai.gov.in/problem-statement): Address Update Using Supporting Document

# Description:
We have made the application using Flutter as a mobile User-Interface framework. External(Fast Api, GeoCode) as well as Internal(Aadhaar Auth API & Aadhaar eKYC API) api's have been used in the backend, they have been connected by using python as a programming language. Finally the backend was deployed using Deta.

Step's:
(**The user will have to give permissions like camera and location**)

1. The operator will have to first enter their Aadhaar card number, which will generate an OTP, which will be sent to their linked mobile number. Once the user has been validated they will be redirected to the main screen.

2. Once the operator has been redirected Original address would have been already filled using eKYC, they will have to enter details like Street, District & Sub-District.

3. In the third step operator will have to scan an offical document with the resendentail address like: Electricity bill, with the help of a Optical Character Recognition (OCR) Scanner which has been provided in the application.

4. In the next step the operator will click on the validate button which commence the verification checks on the information inputted via python, the first check would verify that the district and sub district actually exist in India by search in a database of districts and subdistricts in India, following that check, another one is performed where the latitude and longitude of the device and address inputted is checked if it is in the acceptable range another check is performed to check if the OCR scanned address has the inputted details. If the three above mentioned check return true, the new address is constructed and returns it if it is similiar to the address in the aadhaar card, this check is performed using sequence matcher library.

5. If the address has been validated the operator will have to click a picture of an offical document which was scanned using the OCR scanner for documentation purposes.

6. Firebase is used as backend, audit log will be updated in firestore and official documents will be stored in firebase storage.

# Video
https://youtu.be/Zos6zW_a8yI

# Screenshots
<p align = "center">
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/phone/screen1.png" width="400" />
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/phone/screen2.png" width="400" />
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/phone/screen3.png" width="400" />
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/phone/screen4.png" width="400" />
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/phone/screen6.png" width="400" />
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/phone/screen5.png" width="400" />
  <img src="https://github.com/Abhitay/UIDAI-hackathon-Problem-Statement-2/blob/main/assets/screen/database.PNG" width="800" />
</p>

# Contribution
A project by <br>
- [Maanaav Motiramani](https://github.com/Maanaav) <br>
- [Abhitay Shinde](https://github.com/Abhitay)
- [Anurag Singh](https://github.com/Anurag1902)
- [Parth Mody](https://github.com/ParthMody)
- [Pratham Soni](https://github.com/PrathamSoni4473)
