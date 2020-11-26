import 'dart:convert';

import 'package:covid_app/models/country.dart';
import 'package:covid_app/services/countries.dart';
import 'package:http/http.dart' as http;

List<String> getAllCountries() {
  List<String> allCountries = [];
  countries.forEach((key, value) {
    allCountries.add(value);
  });
  return allCountries;
}

String convertAlpha(var countryName) {
  for (var entry in countries.entries) {
    if (entry.value == countryName) {
      return entry.key;
    }
  }
  return null;
}

Future<Country> fetchData(String countryName) async {
  String alphaCode = convertAlpha(countryName);
  var response =
      await http.get('https://corona-api.com/countries/' + alphaCode);

  if (response.statusCode == 200) {
    return Country.fromJson(countryName, json.decode(response.body));
  } else {
    throw Exception("Data could not be fetched!");
  }
}
