import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({required this.locationWeather});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late int temp;
  late String weatherIcon;
  late String cityName;
  late String message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(weatherData: widget.locationWeather);
  }
  void updateUI({required dynamic weatherData}){
    setState(() {
      if(weatherData==null){
        temp=0;
        weatherIcon='Error';
        message='Unable to load weather';
        cityName='';
        return;
      }
      double temperature=weatherData['main']['temp'];
      temp= temperature.toInt();
      int condition=weatherData['weather'][0]['id'];
      weatherIcon=weatherModel.getWeatherIcon(condition);
      cityName=weatherData['name'];
      message= weatherModel.getMessage(temp);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/location_background.jpg'),
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
                  IconButton(
                    onPressed: () async{
                      var weatherData = await WeatherModel().getLocationWeather();
                      updateUI(weatherData: weatherData);
                    },
                    icon: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  IconButton(
                    onPressed: ()async {
                      var typedName= await Navigator.push(context, MaterialPageRoute(builder: (_)=>CityScreen()));
                      if(typedName!=null){
                        var weatherData =
                        await weatherModel.getCityWeather(typedName);
                        updateUI(weatherData: weatherData);
                      }
                    },
                    icon: Icon(
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
                      '$temp',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  message +"$cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}