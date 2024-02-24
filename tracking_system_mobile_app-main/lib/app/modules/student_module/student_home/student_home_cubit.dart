import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_system_mobile_app/app/modules/driver_module/repository/location_repository.dart';
import '../../modules.dart';
import '../../../sdk/sdk_export.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit(this.context, this._serviceRepository)
      : super(StudentHomeState()) {
    userApi = UserApi();
    _onInit();
  }

  BuildContext context;
  UserApi? userApi;
  LocationServiceRepository _serviceRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  Future<void> _onInit() async {
    await _getStudentCurrentLoction();
  }

  _getStudentCurrentLoction() async {
    final location = await _serviceRepository.fetchLocationByDeviceGPS();
    final user = _auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection("StudentData")
        .where("studentUserId", isEqualTo: user)
        .get();
    final busDocumentId = snapshot.docs.first.data()['busDocumentId'];
    _subscription = _firebaseFirestore
        .collection("Buses")
        .where("busDocumentId", isEqualTo: busDocumentId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs[0].data();

        if (state.busLatitude == null && state.busLongtitude == null) {
          emit(
            state.copyWith(
              status: StudentHomeStatus.loaded,
              studentCurrentLocation: location,
              busDocumentId: busDocumentId,
              busLatitude: data['latitude'],
              busLongtitude: data['longitude'],
            ),
          );
        } else if (state.busLatitude == data["latitude"] &&
            state.busLongtitude == data["longitude"]) {
          emit(
            state.copyWith(
              status: StudentHomeStatus.loaded,
              studentCurrentLocation: location,
              busDocumentId: busDocumentId,
              busLatitude: data['latitude'],
              busLongtitude: data['longitude'],
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: StudentHomeStatus.updated,
              studentCurrentLocation: location,
              busDocumentId: busDocumentId,
              busLatitude: data['latitude'],
              busLongtitude: data['longitude'],
            ),
          );
        }

        _getLocationDetails();
      }
    });
  }

  _getLocationDetails() async {
    final response = await userApi!.getLocationDetails(
      originLat: state.busLatitude!,
      originLong: state.busLongtitude!,
      destLat: state.studentCurrentLocation!.latitude,
      destLong: state.studentCurrentLocation!.longitude,
    );
    if (response != null) {
      final Map<String, dynamic> responseData = response;
      if (responseData.containsKey('routes')) {
        final List<dynamic> routes = responseData['routes'];
        if (routes.isNotEmpty) {
          final Map<String, dynamic> route = routes[0];
          final List<dynamic> legs = route['legs'];
          if (legs.isNotEmpty) {
            final Map<String, dynamic> leg = legs[0];
            final Map<String, dynamic> distance = leg['distance'];
            final Map<String, dynamic> duration = leg['duration'];

            final String distanceText = distance['text'];
            final int distanceValue = distance['value'];

            final String durationText = duration['text'];
            final int durationValue = duration['value'];

            emit(state.copyWith(
                distance: distanceText, timeDuration: durationText));
            print('Distance: $distanceText ($distanceValue)');
            print('Duration: $durationText ($durationValue)');
          }
        }
      }
    }
  }

  Future<bool> logout() async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    return true;
  }
}
