import requests
import urllib.parse
from difflib import SequenceMatcher
from fastapi import FastAPI

app = FastAPI()


@app.get('/{tempAddress1}/{tempAddress2}/{tempAddress3}/{OriginalAddress}/{OcrAddress}/{x}/{y}')
async def getData(tempAddress1, tempAddress2, tempAddress3, OriginalAddress, OcrAddress, x, y):
    def contains(TestVar, elements):
        #print(TestVar, elements)
        for element in elements:
            if element == TestVar:
                return True
        return False

    def validate_bill(strTest, updatedAddress):
        #print(strTest, updatedAddress)
        billList = list((strTest.replace(',', '')).split(' '))
        updatedAddressList = list((updatedAddress.replace(',', '')).split(' '))
        # print(billList)
        # print(updatedAddressList)
        for elements in billList:
            if contains(elements, updatedAddressList):
                # print(elements)
                return True
        return False

    def getLat(tempAddress1):
        url = 'https://nominatim.openstreetmap.org/search/' + urllib.parse.quote(tempAddress1) + '?format=json'
        response = requests.get(url).json()
        # print(response)
        return response[0]["lat"]

    def getLong(tempAddress1):
        url = 'https://nominatim.openstreetmap.org/search/' + urllib.parse.quote(tempAddress1) + '?format=json'
        response = requests.get(url).json()
        # print(response)
        return response[0]["lon"]

    def validate_location(devlat, devlong, addlat, addlong):
        # print(devlat)
        # print(devlong)
        # print(addlat)
        # print(addlong)
        if float(addlat) * 0.999 <= float(devlat) <= float(addlat) * 1.001 and float(addlong) * 0.999 <= float(
                devlong) <= float(addlong) * 1.001:
            return True
        return False

    def similar(a, b):
        ratio = SequenceMatcher(None, a, b).ratio()
        # print(ratio)
        if ratio > 0.6:
            return True

    # Take all the data from flutter
    # tempAddress1 = input("Enter the street name: ")
    # tempAddress2 = input("Enter the sub district: ")
    # tempAddress3 = input("Enter the district: ")
    # OriginalAddress = input("Enter original address: ")
    # OcrAddress = '27, Mayawati Goregaon, Swati Nagar, 123497, India'
    # x = '19.1648029'
    # y = '72.8500454'
    # -----------------------------------------
    updatedAddress = tempAddress1 + ', ' + tempAddress2 + ', ' + tempAddress3
    if tempAddress1:
        addLat = str(getLat(tempAddress1))
        addLong = str(getLong(tempAddress1))
    elif tempAddress2:
        addLat = str(getLat(tempAddress2))
        addLong = str(getLong(tempAddress2))
    elif tempAddress3:
        addLat = str(getLat(tempAddress3))
        addLong = str(getLong(tempAddress3))
    # print(addLat)
    # print(addLong)

    # newAddress= OriginalAddress
    # print(newAddress)
    
    if validate_bill(OcrAddress, updatedAddress) and validate_location(x, y, addLat, addLong):
        newAddress = OriginalAddress + ',' + updatedAddress
        if similar(newAddress, OcrAddress):
            print(newAddress)
    # print(newAddress)
    return newAddress
