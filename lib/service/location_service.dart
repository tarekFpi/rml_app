import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:maps_toolkit/maps_toolkit.dart' as mapToolKit;
import 'package:tmv_lite/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as Math;
import 'dart:math' show cos, sqrt, asin;
import 'dart:ui' as ui;

enum LocationStatus {
  SERVICE_DISABLE,
  PERMISSION_DENIED,
  DENIED_PERMANENTLY,
  PERMISSION_OK
}

class LocationService {
  static Future<LocationStatus> getLocationState() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return LocationStatus.SERVICE_DISABLE;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return LocationStatus.PERMISSION_DENIED;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return LocationStatus.DENIED_PERMANENTLY;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return LocationStatus.PERMISSION_OK;
  }

  static Future<void> openMapApp(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) return;
    Uri googleUrl = Uri.parse(
        'google.navigation:q=$latitude,$longitude&mode=d');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      Toast.errorToast("Unable open the map.", "Check if google map installed");
    }
  }

  static double radiansToDegrees(double x) {
    return x * 180.0 / Math.pi;
  }

  static double calculateRotation(LatLng? lastLatLng, LatLng? currentLatLng) {
    if(lastLatLng == null || currentLatLng == null) return 0;
    double fLat = (Math.pi * lastLatLng.latitude) / 180.0;
    double fLng = (Math.pi * lastLatLng.longitude) / 180.0;
    double tLat = (Math.pi * currentLatLng.latitude) / 180.0;
    double tLng = (Math.pi * currentLatLng.longitude) / 180.0;

    double degree = radiansToDegrees(Math.atan2(
        Math.sin(tLng - fLng) * Math.cos(tLat),
        Math.cos(fLat) * Math.sin(tLat) -
            Math.sin(fLat) * Math.cos(tLat) * Math.cos(tLng - fLng)));

    double bearing = 0;
    if (degree >= 0) {
      bearing = degree;
    } else {
      bearing = 360 + degree;
    }
    return bearing;
  }

  static Future<BitmapDescriptor> generateMarkerFromAsset(
      String path,{Size? size}) async {
    try {

      //image size not reducing in ios that is why we are checking condition
      if(Platform.isIOS){
        final Uint8List? markerIcon = await getBytesFromAsset(path, 50);
        if(markerIcon != null){
          return BitmapDescriptor.fromBytes(markerIcon);
        }
      }
      return await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: size ?? const Size(20, 20)), path);
    } catch (e) {
      throw 'Unable to convert marker';
    }
  }

  static Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }

  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  static double getDistanceAsKm(List<LatLng> latLng){
    double totalDistance = 0;
    for(var i = 0; i < latLng.length-1; i++){
      totalDistance += calculateDistance(latLng[i].latitude, latLng[i].longitude, latLng[i+1].latitude, latLng[i+1].longitude);
    }
    return totalDistance;
  }

  static LatLngBounds reduceLatLngBoundBy(LatLngBounds bounds, double percentage){

    final distance = mapToolKit.SphericalUtil.computeDistanceBetween(mapToolKit.LatLng(bounds.northeast.latitude, bounds.northeast.longitude), mapToolKit.LatLng(bounds.southwest.latitude, bounds.southwest.longitude));
    final reduced = distance * percentage;

    final headingNESW = mapToolKit.SphericalUtil.computeHeading(mapToolKit.LatLng(bounds.northeast.latitude, bounds.northeast.longitude), mapToolKit.LatLng(bounds.southwest.latitude, bounds.southwest.longitude));

    final newNE = mapToolKit.SphericalUtil.computeOffset(mapToolKit.LatLng(bounds.northeast.latitude, bounds.northeast.longitude), reduced / 2.0, headingNESW);

    final headingSWNE = mapToolKit.SphericalUtil.computeHeading(mapToolKit.LatLng(bounds.southwest.latitude, bounds.southwest.longitude), mapToolKit.LatLng(bounds.northeast.latitude, bounds.northeast.longitude));
    final newSW = mapToolKit.SphericalUtil.computeOffset(mapToolKit.LatLng(bounds.southwest.latitude, bounds.southwest.longitude), reduced / 2.0, headingSWNE);

    return LatLngBounds(southwest: LatLng(newSW.latitude, newSW.longitude), northeast: LatLng(newNE.latitude, newNE.longitude));
  }
}
