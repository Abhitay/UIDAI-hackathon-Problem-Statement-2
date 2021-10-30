import requests
import urllib.parse
from difflib import SequenceMatcher
from fastapi import FastAPI
from geopy.geocoders import Nominatim
import pandas as pd

geolocator = Nominatim(user_agent="geoapiExercises")

app = FastAPI()

@app.get('/{tempAddress1}/{tempAddress2}/{tempAddress3}/{OriginalAddress}/{OcrAddress}/{x}/{y}')
async def getData(tempAddress1, tempAddress2, tempAddress3, OriginalAddress, OcrAddress, x, y):


    def contains(TestVar, elements):
        #print(TestVar, elements)
        for element in elements:
            if element == TestVar:
                #print('True')
                return True
        return False


    def validate_bill(strTest, updatedAddress):
        #print(strTest, updatedAddress)
        billList = list((strTest.replace(',', '')).split(' '))
        updatedAddressList = list((updatedAddress.replace(',', ' ')).split(' '))
        # print(billList)
        # print(updatedAddressList)
        for elements in billList:
            if contains(elements, updatedAddressList):
                # print(elements)
                return True
        return False


    def getLat(tempAddress1):
        url = 'https://nominatim.openstreetmap.org/search/' + \
            urllib.parse.quote(tempAddress1) + '?format=json'
        response = requests.get(url).json()
        # print(response)
        if response:
            return response[0]["lat"]
        else:
            return 0


    def getLong(tempAddress1):
        url = 'https://nominatim.openstreetmap.org/search/' + \
            urllib.parse.quote(tempAddress1) + '?format=json'
        response = requests.get(url).json()
        # print(response)
        if response:
            return response[0]["lon"]
        else:
            return 0


    def validate_location(devlat, devlong, addlat, addlong):
        # print(devlat)
        # print(devlong)
        # print(addlat)
        # print(addlong)
        if float(addlat) * 0.9 <= float(devlat) <= float(addlat) * 1.1 and float(addlong) * 0.9 <= float(
                devlong) <= float(addlong) * 1.1:
            return True
        return False


    def similar(a, b):
        ratio = SequenceMatcher(None, a, b).ratio()
        # print(ratio)
        if ratio > 0.6:
            return True


    def OcrAddressCheck(OcrAddress,district,sub_district):
        districtNames = pd.read_csv('Districts.csv')
        subDistrictNames = pd.read_csv('Sub_districts.csv')
        districtNamesList = list(districtNames['Districts'])
        subDistrictNamesList = list(subDistrictNames['Sub_districts'])
        ocrAddressList = list((OcrAddress.replace(',', '')).split(' '))

        i = 0
        # print('Districts')
        if district:
            for elements in districtNamesList:

                if contains(elements.lower(), ocrAddressList):
                    # print('districtNamesList')
                    i += 1
                    #print(i)
                    break
        else:
            i+=1
        #print('Sub Districts')
        if sub_district:
            for elements in subDistrictNamesList:

                if contains(elements.lower(), ocrAddressList):
                    #print('subDistrictNamesList')
                    # print(elements)
                    #print(i)
                    i += 1
                    break
        else:
            i+=1
        #print('end',i)
        if i == 2:
            return True
        return False


    # -----Take all the data from flutter------
    # tempAddress1 = input("Enter the street name: ")
    # tempAddress2 = input("Enter the sub district: ")
    # tempAddress3 = input("Enter the district: ")
    # OriginalAddress = input("Enter original address: ")
    # OcrAddress = input("Enter OCR address: ")
    # x = '19.1648029'
    # y = '72.8500454'
    # -----------------------------------------
    tempAddress1 = tempAddress1.lower()
    tempAddress2 = tempAddress2.lower()
    tempAddress3 = tempAddress3.lower()
    OriginalAddress = OriginalAddress.lower()
    OcrAddress = OcrAddress.lower()

    updatedAddress = tempAddress1 + ',' + tempAddress2 + ',' + tempAddress3
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

    newAddress = 'Address Not Verified'
    # print(newAddress)
    # location = geolocator.reverse(x+","+y)
    # address = location.raw['address']
    # district = address.get('state_district', '')
    # sub_district = address.get('suburb', '')
    # street = address.get('street', '')
    # print(district)
    # print(sub_district)
    # print(street)

    # print(tempAddress1, '\n', tempAddress2, '\n', tempAddress3, '\n',
    #       OriginalAddress, '\n', OcrAddress, '\n', updatedAddress, '\n', x, '\n', y, '\n', addLat, '\n', addLong, '\n', validate_bill(OcrAddress, updatedAddress), '\n', validate_location(x, y, addLat, addLong), '\n', OcrAddressCheck(OcrAddress))

    if validate_bill(OcrAddress, updatedAddress) and validate_location(x, y, addLat, addLong) and OcrAddressCheck(OcrAddress,tempAddress2, tempAddress3):
        newAddress = OriginalAddress + ', ' + updatedAddress
        if similar(newAddress, OcrAddress):
            newAddress = newAddress.replace(',', ' ')
            newAddress = newAddress.replace('  ', ' ')
            newAddress = newAddress.title()
            if OcrAddress:
                print(OriginalAddress, '\n', 'Street Name: ', tempAddress1.title(),
                    '\n', 'Sub district: ', tempAddress2.title(), '\n', 'District: ', tempAddress3.title(), '\n', 'Complete Address: ', newAddress)
                #return newAddress
            elif OcrAddress ==' ':
                print('Address Not Verfied')
                #return 'Address Not Verfied'
