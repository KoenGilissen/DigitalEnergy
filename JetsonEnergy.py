import sys
import requests
import pandas as pd
import datetime as dt
import json
from pvlib.forecast import GFS
import os


def create_filename(fn):
    loopIndex = 0
    while os.path.isfile(fn):
        fn = fn.replace(".json", "_" + str(loopIndex) + ".json")
        loopIndex += 1
        if loopIndex > 100:
            break
    return fn


if __name__ == '__main__':
    timeZone = "Europe/Brussels"
    latitude = 50.874
    longitude = 5.274
    currentTime = dt.datetime.now()
    currentTimeString = currentTime.strftime("%Y%m%d")

    # Create API CALL Solcast
    solcast_endpoint = "https://api.solcast.com.au/world_radiation/forecasts"
    solcast_parameters = {"latitude": latitude, "longitude": longitude, "hours": 24,
                          "api_key": "CwY233fnKpxH1RwNr43pZnUuopKlnC_C", "format": "json"}
    # Create filename based on current Time and Date
    SolcastFilename = create_filename(currentTimeString + "_solcast.json")
    # Do the Request
    solcast_request = requests.get(url=solcast_endpoint, params=solcast_parameters)
    if solcast_request.status_code != 200:
        sys.exit("[ERROR] Solcast request returned: " + str(solcast_request.status_code))
    # Solcast data to file
    open(SolcastFilename, "wb").write(solcast_request.content)
    #print(solcast_request.content)
    # Solcast data to dataframe
    data = json.loads(solcast_request.content)
    df = pd.json_normalize(data['forecasts'])

    # Create API CALL GFS
    model = GFS()
    start = pd.Timestamp(dt.date.today(), tz=timeZone)
    end = start + pd.Timedelta(days=2)
    gfs_Data = model.get_data(latitude, longitude, start, end)
    gfs_Data = model.rename(gfs_Data)
    gfs_Data['wind_speed'] = model.uv_to_speed(gfs_Data)
    fileToWrite = create_filename(currentTimeString + "_gfs.json")
    print("Creating file: " + fileToWrite)
    gfs_Data.to_json(fileToWrite)

    # Create API CALL Open Weather
    openWeather_endpoint = "https://pro.openweathermap.org/data/2.5/forecast/hourly"
    openWeather_parameters = {"lat": latitude, "lon": longitude, "mode": "json", "units": "metric",
                              "appid": "2ddb6a0d75a6770a85d6ae06166bb69c"}
    openWeather_request = requests.get(url=openWeather_endpoint, params=openWeather_parameters)
    if openWeather_request.status_code != 200:
        sys.exit("[ERROR] Open Weather request returned: " + str(openWeather_request.status_code))
    OpenWeatherFilename = create_filename(currentTimeString + "_openweather.json")
    print("Creating File: " + OpenWeatherFilename)
    open(OpenWeatherFilename, "wb").write(openWeather_request.content)
