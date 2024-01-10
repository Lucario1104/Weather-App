import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_forecast_card.dart';
import 'package:weather_icons/weather_icons.dart';
import 'add_info_card.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      String cityName = 'Nashik';
      final res = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final data = snapshot.data;
          final currentTemp =
              (data['list'][0]['main']['temp'] - 273.15).toStringAsFixed(0);
          final aasman = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final feelsLike = (data['list'][0]['main']['feels_like'] - 273.15)
              .toStringAsFixed(0);
          final windSpeed = data['list'][0]['wind']['speed'];
          final pressure = data['list'][0]['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //////  Box 1  //////

                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.lightBlueAccent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C',
                                style: const TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              Icon(
                                aasman == 'Clouds'
                                    ? WeatherIcons.cloud
                                    : aasman == 'Clear'
                                        ? WeatherIcons.day_sunny
                                        : WeatherIcons.raindrops,
                                size: 65,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                aasman,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),

                ////// Box 2 //////

                SizedBox(
                  height: 145,
                  child: ListView.builder(
                      itemCount: 9,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return WeatherForecastCard(
                          time: DateFormat.j().format(DateTime.parse(
                              data['list'][index + 1]['dt_txt'])),
                          icon: data['list'][index + 1]['weather'][0]['main'] ==
                                  'Clouds'
                              ? WeatherIcons.cloud
                              : data['list'][index + 1]['weather'][0]['main'] ==
                                      'Clear'
                                  ? WeatherIcons.day_sunny
                                  : WeatherIcons.raindrops,
                          temperature:
                              '${(data['list'][index + 1]['main']['temp'] - 273.15).toStringAsFixed(0)}°C',
                        );
                      }),
                ),

                const SizedBox(
                  height: 15,
                ),

                ////// Box 3 //////

                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AddInfoCard(
                          icon: Icons.thermostat,
                          property: 'Feels Like',
                          value: '$feelsLike°C'),
                      AddInfoCard(
                        icon: Icons.water_drop,
                        property: 'Humidity',
                        value: '$humidity%',
                      ),
                      AddInfoCard(
                        icon: Icons.air,
                        property: 'Wind Speed',
                        value: '$windSpeed km/hr',
                      ),
                      AddInfoCard(
                        icon: WeatherIcons.barometer,
                        property: 'Pressure',
                        value: '$pressure hPa',
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
