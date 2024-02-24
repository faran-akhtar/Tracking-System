import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../driver_module_export.dart';
import '../../../sdk/sdk_export.dart';

class DriverHomeCubit extends Cubit<DriverHomeState> {
  final LocationServiceRepository locationServiceRepository;
  DriverHomeCubit(
    this.context,
    this.locationServiceRepository,
   
  ) : super(DriverHomeState()) {
    _onInit();
  }

  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late BackgroundService backgroundService;
   

  Future<void> _onInit() async {
    await getStudentData();
  }

  Future<void> getStudentData() async {
    emit(state.copyWith(status: DriverHomeStatus.loading));
    try {
       final location = await locationServiceRepository.fetchLocationByDeviceGPS();
      final user = _auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection("DriverData")
          .where("driverUserId", isEqualTo: user)
          .get();
      final busDocumentId = snapshot.docs.first.data()['busDocumentId'];
      QuerySnapshot<Map<String, dynamic>> studentSnapshot =
          await _firebaseFirestore
              .collection("StudentData")
              .where("busDocumentId", isEqualTo: busDocumentId)
              .get();

      final List studentData =
          studentSnapshot.docs.map((e) => e.data()).toList();
      print(studentData);
     emit(state.copyWith(studentData: studentData, status: DriverHomeStatus.loaded, driverCurrentLocation: location));
    } catch (e) {
      print(e.toString());
    }
  }

  updateRun() {
    emit(state.copyWith(runStatus: RunStatus.start));
  }

  updateRunStop() {
    emit(state.copyWith(runStatus: RunStatus.none));
  }

  Future<void> onLocationChanged({
    required Position location,
  }) async {
    try {
      emit(
        state.copyWith(
          location: location,
          runStatus: RunStatus.start,
        ),
      );
      updateBusLocation();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<bool> enableGPSWithPermission() async {
    try {
      await locationServiceRepository.fetchLocationByDeviceGPS();
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future<Position?> locationFetchByDeviceGPS() async {
    try {
      final selectedLocation =
          await locationServiceRepository.fetchLocationByDeviceGPS();
      emit(state.copyWith(
        location: selectedLocation,
      ));
      return selectedLocation;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      return null;
    }
  }



  Future<void> updateBusLocation() async {
    if (state.location != null) {
      try {
        final user = _auth.currentUser!.uid;
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
            .collection("DriverData")
            .where("driverUserId", isEqualTo: user)
            .get();

        final busDocumentId = snapshot.docs.first.data()['busDocumentId'];
        QuerySnapshot<Map<String, dynamic>> busSnapshot =
            await _firebaseFirestore
                .collection("Buses")
                .where("busDocumentId", isEqualTo: busDocumentId)
                .get();
        DocumentSnapshot<Map<String, dynamic>> busDocument =
            busSnapshot.docs.first;
        await busDocument.reference.update({
          "latitude": state.location!.latitude,
          "longitude": state.location!.longitude
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      if (await Permission.locationAlways.isGranted) {
        return true;
      } else {
        openAppSettings();
        print('Location permission granted only while using the app');
      }
    } else if (permissionStatus == PermissionStatus.denied) {
      Permission.location.request();
      return false;
    }
    return false;
  }

  Future<bool> logout() async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    return true;
  }
}
