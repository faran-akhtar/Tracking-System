import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../modules.dart';
import '../../../styles/style.dart';
import '../../../routes/routes_export.dart';
import 'dart:ui' as ui;

// ignore: must_be_immutable
class StudentHome extends StatefulWidget {
  StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDYfG5HAhngj0NdM8MPx4ioO6nzmXfT3cI";
  double distance = 0.0;
  Uint8List? markerIcon;

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine({required final List<LatLng> polylineCoordinates}) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(double originLat, double originLong, double destLat,
      double destLong) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(originLat, originLong),
      PointLatLng(destLat, destLong),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      _clearPolylines();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));

        _addPolyLine(polylineCoordinates: polylineCoordinates);
      });
    }
  }

  _clearPolylines() {
    polylineCoordinates.clear();
    polylines.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              height: Sizes.s56,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.s16,
              ),
              decoration: const BoxDecoration(
                color: CustomColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.shadowColor2,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Pages',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.studentAttendanceScreen,
                ).then((value) {
                  //  Navigator.pop(context);
                });
              },
              title: const Text(
                'Attendance',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.add,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: Colors.black38,
                thickness: 0.1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.studentProfileScreen,
                );
              },
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.person,
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            "Student Home",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlutterTextTheme.lightTextTheme.headline4?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () async {
                final result = await context.read<StudentHomeCubit>().logout();
                if (result) {
                  Navigator.of(context).pushReplacementNamed(Routes.initial);
                }
              },
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              splashRadius: 24,
              constraints: const BoxConstraints(
                maxHeight: 40,
                maxWidth: 40,
                minHeight: 40,
                minWidth: 40,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<StudentHomeCubit, StudentHomeState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          switch (state.status) {
            case StudentHomeStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (state.busDocumentId == null) {
                return const Center(
                  child: Text('No Data'),
                );
              }
              _addMarker(
                  LatLng(state.studentCurrentLocation!.latitude,
                      state.studentCurrentLocation!.longitude),
                  "origin",
                  BitmapDescriptor.defaultMarker);

              /// destination marker

              _addMarker(
                  LatLng(
                    state.busLatitude!,
                    state.busLongtitude!,
                  ),
                  "destination",
                  BitmapDescriptor.fromBytes(markerIcon!));
              polylines.values.isEmpty
                  ? _getPolyline(
                      state.studentCurrentLocation!.latitude,
                      state.studentCurrentLocation!.longitude,
                      state.busLatitude!,
                      state.busLongtitude!,
                    )
                  : state.status == StudentHomeStatus.updated
                      ? _getPolyline(
                          state.studentCurrentLocation!.latitude,
                          state.studentCurrentLocation!.longitude,
                          state.busLatitude!,
                          state.busLongtitude!,
                        )
                      : () {};

              return Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.studentCurrentLocation!.latitude,
                          state.studentCurrentLocation!.longitude,
                        ),
                        zoom: 12.4746),
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  BlocBuilder<StudentHomeCubit, StudentHomeState>(
                    builder: (context, state) {
                      if (state.distance == null ||
                          state.timeDuration == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Positioned(
                        left: 0,
                        right: 0,
                        bottom: 80,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          height: 60, // Adjust the height as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Distance: ${state.distance}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Travel Time: ${state.timeDuration}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
