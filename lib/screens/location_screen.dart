import 'package:flutter/material.dart';
import 'package:flutter_weather/services/weather.dart';
import 'package:flutter_weather/screens/city_screen.dart';
import 'package:flutter_weather/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  int temperature;
  String condition;
  String cityName;
  String conditionMessage;

  WeatherModel weather = WeatherModel();


  @override
  void initState() {
    super.initState();
    updateWeather(widget.locationWeather);
  }

  void updateWeather(dynamic weatherData){
    var temp = weatherData['main']['temp'];
    var cond  = weatherData['weather'][0]['id'];
    var city = weatherData['name'];
    setState(() {
      if(weatherData == null){
        temperature = 0;
        condition = 'Error';
        conditionMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      cityName = city;
      temperature = temp.toInt();
      condition = weather.getWeatherIcon(cond);
      conditionMessage = weather.getMessage(temperature);
    });
    print(temperature);
    print(condition);
    print(cityName);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/location_background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateWeather(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context,MaterialPageRoute(builder: (context)=> CityScreen()));
                      if(typedName != null){
                        var weatherData = await weather.getCityWeather(typedName);
                        updateWeather(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temperature.toString(),
                      style: kTempTextStyle,
                    ),
                    Text(
                      condition,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    conditionMessage+" in "+cityName,
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

