import 'package:flutter/material.dart';
import '../models/note.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAppState extends ChangeNotifier {
  List<Note> notes = [];
  String? weatherInfo;

  Future<void> fetchWeather() async {

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=52.2296&longitude=21.0122&current=temperature_2m,relative_humidity_2m,weather_code&temperature_unit=celsius',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current']; 
        final temperature = current['temperature_2m'];
        final humidity = current['relative_humidity_2m'];
        weatherInfo = "Temperature: $temperature°C\nHumidity: $humidity%";
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      print('Error: $e');
      weatherInfo = 'Error: $e';
      rethrow;
    } finally{
       notifyListeners();
    }
  }

  void addNote(String title, String content){
    final note = Note(
      id: DateTime.now().toString(),
      title: title,
      content: content,
      createdAt: DateTime.now()
    );
    notes.add(note);
    notifyListeners();
  }

  void deleteNote (String id){
    notes.removeWhere((note)=>note.id==id);
    notifyListeners();
  }

  void updateNote (String id, String title, String content){
    final index = notes.indexWhere((note)=>note.id==id);
    if (index !=-1){
      notes[index]=Note(
        id:id,
        title: title,
        content: content,
        createdAt: notes[index].createdAt,
      );
    }
    notifyListeners();
  }
}