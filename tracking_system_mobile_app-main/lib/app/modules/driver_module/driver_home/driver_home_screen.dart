import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../driver_module_export.dart';
import '../../../sdk/sdk_export.dart';
import '../../../routes/routes_export.dart';
import 'dart:ui' as ui;

// ignore: must_be_immutable
class DriverHomeScreen extends StatefulWidget {
  DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  late BackgroundService backgroundService;
  int polyLineIdCounter = 1;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDYfG5HAhngj0NdM8MPx4ioO6nzmXfT3cI";
  Uint8List? markerIcon;
  List<LatLng> listLocations = [];
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _clearPolylines() {
    polylineCoordinates.clear();
    polylines.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    backgroundService = BackgroundService();
    loadIcon();
  }

  loadIcon() async {
    markerIcon = await getBytesFromAssets("assets/images/car.jpg", 70);
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMultiplePolyLines(var studentData, var currentLatLong) async {
    await Future.forEach(studentData, (LatLng elem) async {
      await _getRoutePolyline(
        start: currentLatLong!,
        finish: elem,
        color: Colors.green,
        id: 'firstPolyline $elem',
        width: 4,
      );
    });

    setState(() {});
  }

  Future<Polyline> _getRoutePolyline(
      {required LatLng start,
      required LatLng finish,
      required Color color,
      required String id,
      int width = 6}) async {
    final polylinePoints = PolylinePoints();
    final List<LatLng> polylineCoordinates = [];

    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      startPoint,
      finishPoint,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }

    polyLineIdCounter++;

    final Polyline polyline = Polyline(
        polylineId: PolylineId(id),
        consumeTapEvents: true,
        points: polylineCoordinates,
        color: Colors.red,
        width: 6,
        onTap: () {});

    setState(() {
      polylines[PolylineId(id)] = polyline;
    });

    return polyline;
  }

  @pragma('vm:entry-point')
  @override
  Future<void> didChangeDependencies() async {
    await context.read<NotificationService>().initialize(context);
    //Start the service automatically if it was activated before closing the application
    if (await backgroundService.instance.isRunning()) {
      await backgroundService.initializeService();
    }
    backgroundService.instance.on('on_location_changed').listen((event) async {
      if (event != null) {
        final position = Position(
          longitude: double.tryParse(event['longitude'].toString()) ?? 0.0,
          latitude: double.tryParse(event['latitude'].toString()) ?? 0.0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              event['timestamp'].toInt(),
              isUtc: true),
          accuracy: double.tryParse(event['accuracy'].toString()) ?? 0.0,
          altitude: double.tryParse(event['altitude'].toString()) ?? 0.0,
          heading: double.tryParse(event['heading'].toString()) ?? 0.0,
          speed: double.tryParse(event['speed'].toString()) ?? 0.0,
          speedAccuracy:
              double.tryParse(event['speed_accuracy'].toString()) ?? 0.0,
        );

        await context
            .read<DriverHomeCubit>()
            .onLocationChanged(location: position);
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        label: 'Driver Home',
        onLogoutPressed: () async {
          final result = await context.read<DriverHomeCubit>().logout();
          if (result) {
            Navigator.of(context).pushReplacementNamed(Routes.initial);
          }
        },
      ),
      body: BlocBuilder<DriverHomeCubit, DriverHomeState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          switch (state.status) {
            case DriverHomeStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (state.studentData!.isEmpty) {
                return const Center(
                  child: Text('No Data'),
                );
              }

              for (int i = 0; i < state.studentData!.length; i++) {
                _addMarker(
                    LatLng(state.studentData![i]["pickupLatitude"],
                        state.studentData![i]["pickupLongitude"]),
                    state.studentData![i]["studentUserId"],
                    BitmapDescriptor.defaultMarker);
              }

              _addMarker(
                  LatLng(
                    state.location != null
                        ? state.location!.latitude
                        : state.driverCurrentLocation!.latitude,
                    state.location != null
                        ? state.location!.longitude
                        : state.driverCurrentLocation!.longitude,
                  ),
                  "origin",
                  BitmapDescriptor.fromBytes(markerIcon!));

              for (int i = 0; i < state.studentData!.length; i++) {
                listLocations.add(LatLng(
                    state.studentData![i]["pickupLatitude"],
                    state.studentData![i]["pickupLongitude"]));
              }
              getMultiplePolyLines(
                      listLocations,
                      LatLng(
                        state.location != null
                            ? state.location!.latitude
                            : state.driverCurrentLocation!.latitude,
                        state.location != null
                            ? state.location!.longitude
                            : state.driverCurrentLocation!.longitude,
                      ),
                    );

              return GoogleMap(
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: state.location != null
                        ? LatLng(
                            state.location!.latitude,
                            state.location!.longitude,
                          )
                        : LatLng(
                            state.driverCurrentLocation!.latitude,
                            state.driverCurrentLocation!.longitude,
                          ),
                    zoom: 12.4746),
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
          }
        },
      ),
    );
  }
}
