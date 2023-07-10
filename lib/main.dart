import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _location = '';
  String _temperature = '';
  String _description = '';
  String _icon = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final apiKey = '8bd4d931667f26e81117adce9937844f'; // Replace with your API key
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=Rajshahi&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _location = data['name'];
          _temperature = (data['main']['temp'] - 273.15).toStringAsFixed(1);
          _description = data['weather'][0]['main'];
          _icon = data['weather'][0]['icon'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        backgroundColor: Colors.blue[300],
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : _hasError
              ? Text('Error fetching weather data')
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _location,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Image.network(
                'https://openweathermap.org/img/wn/$_icon.png',
                width: 64,
                height: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Temperature: $_temperature°C',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Description: $_description',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
