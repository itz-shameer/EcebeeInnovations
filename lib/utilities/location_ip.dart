import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LocationIp {
  Future<Map<String, String>> getLocationDetails() async {
    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. Enable them in settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Reverse geocoding to get city and state
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          'city': place.locality ?? 'Unknown',
          'state': place.administrativeArea ?? 'Unknown',
        };
      } else {
        throw Exception('No placemarks found.');
      }
    } catch (e) {
      log('Error retrieving location: $e');
      return {'city': 'Unknown', 'state': 'Unknown'};
    }
  }

  Future<String> ipAdreess(BuildContext context) async {
    final networkInfo = NetworkInfo();

    try {
      final ipAddress = await networkInfo.getWifiIP();
      if (ipAddress != null) {
        log("The Ip Address is $ipAddress");
        return ipAddress;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to retrieve IP Address')));

        throw Exception('Unambee to retrive IP Address');
      }
    } catch (e) {
      log("Error retrive ip address $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to retrieve IP Address : $e')));
      throw Exception('Error retrieving IP Address: $e');
    }
  }
}
