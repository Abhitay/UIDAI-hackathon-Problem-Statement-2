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
                # print('True')
                return True
        return False

    def validate_bill(strTest, tempAddress1, tempAddress2, tempAddress3):
        #print(strTest, updatedAddress)
        strTest = strTest.replace(', ', ' ')
        strTest = strTest.replace(',', ' ')
        while strTest.find('  ') > 0:
            strTest.replace('  ', ' ')
        billList = list((strTest).split(' '))
        print(billList)
        # print(billList)
        # print(updatedAddressList)
        i = 0
        #print(i)
        if tempAddress1:
            # print('tempAddress1 exists')
            for elements in billList:
                #print(elements)
                if elements in tempAddress1:
                    i += 1
                    #print(i)
                    break
        else:
            i += 1
        #print('tempAddress1', i)
        if tempAddress2:
            # print('tempAddress2 exists')

            for elements in billList:
                if elements in tempAddress2:
                    i += 1
                    #print(i)
                    break
        else:
            i += 1
        #print('tempAddress2', i)
        if tempAddress3:
            # print('tempAddress3 exists')

            for elements in billList:
                if elements in tempAddress3:
                    i += 1
                    #print(i)
                    break
        else:
            i += 1
        #print('tempAddress3', i)
        if i == 3:
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


    def OcrAddressCheck(OcrAddress, district, sub_district):
        districtNames = pd.read_csv('Districts.csv')
        subDistrictNames = pd.read_csv('Sub_districts.csv')
        districtNamesList = list(districtNames['Districts'])
        subDistrictNamesList = list(subDistrictNames['Sub_districts'])
        OcrAddress = OcrAddress.replace(', ', ' ')
        OcrAddress = OcrAddress.replace(',', ' ')
        while OcrAddress.find('  ') >0:
            OcrAddress.replace('  ', ' ')
        ocrAddressList = list((OcrAddress).split(' '))

        i = 0
        # print('Districts')
        if district:
            for elements in districtNamesList:
                if contains(elements.lower(), ocrAddressList):
                    # print('districtNamesList')
                    i += 1
                    # print(i)
                    break
        else:
            i += 1
        #print('Districts',i)
        #print('Sub Districts')
        if sub_district:
            for elements in subDistrictNamesList:
                if contains(elements.lower(), ocrAddressList):
                    # print('subDistrictNamesList')
                    # print(elements)
                    # print(i)
                    i += 1
                    break
        else:
            i += 1
        # print('end',i)
        #print('Sub Districts',i)
        if i == 2:
            return True
        return False

    def districtCheck(tempAddress3):
        districtNames = pd.read_csv('Districts.csv')
        districtNamesList = list(districtNames['Districts'])
        if tempAddress3:
            for elements in districtNamesList:
                if elements.lower()== tempAddress3:
                    return True
        return False


    def subDistrictCheck(tempAddress2):
        subDistrictNames = pd.read_csv('Sub_districts.csv')
        subDistrictNamesList = list(subDistrictNames['Sub_districts'])
        if tempAddress3:
            for elements in subDistrictNamesList:
                if elements.lower() == tempAddress2:
                    return True
        return False

    # -----Take all the data from flutter------
    # tempAddress1 = input("Enter the street name: ")
    # tempAddress2 = input("Enter the sub district: ")
    # tempAddress3 = input("Enter the district: ")
    # OriginalAddress = input("Enter original address: ")
    # OcrAddress = input("Enter OCR address: ")
    # x = '19.1890'
    # y = '72.8355'
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

    newAddress = ''
    # print(newAddress)
    # location = geolocator.reverse(x+","+y)
    # address = location.raw['address']
    # district = address.get('state_district', '')
    # sub_district = address.get('suburb', '')
    # street = address.get('street', '')
    # print(district)
    # print(sub_district)
    # print(street)
    
    OriginalAddressList = list((OriginalAddress.replace(',', '')).split(' '))
    # print(tempAddress1, '\n', tempAddress2, '\n', tempAddress3, '\n',
    #       OriginalAddress, '\n', OcrAddress, '\n', updatedAddress, '\n', x, '\n', y, '\n', addLat, '\n', addLong, '\n', validate_bill(OcrAddress, tempAddress1, tempAddress2, tempAddress3), '\n', validate_location(x, y, addLat, addLong), '\n', OcrAddressCheck(OcrAddress, tempAddress2, tempAddress3))
    #k = l = m = 0
    # print(validate_bill(OcrAddress, tempAddress1, tempAddress2, tempAddress3), '\n', validate_location(x, y, addLat, addLong), '\n', OcrAddressCheck(OcrAddress, tempAddress2, tempAddress3))
    if validate_bill(OcrAddress, tempAddress1, tempAddress2, tempAddress3) and validate_location(x, y, addLat, addLong) and OcrAddressCheck(OcrAddress, tempAddress2, tempAddress3):
        # print('validate_bill')
        OcrAddress = OcrAddress.title()
        if OcrAddress and districtCheck(tempAddress3) and subDistrictCheck(tempAddress2):
            return OcrAddress
        else:
            return 'Address Not Verified'
            
