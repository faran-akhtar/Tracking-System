// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DriverHomeStatus {
  none,
  loading,
  loaded,
}

enum RunStatus {
  none,
  start,
  end,
}

// ignore: must_be_immutable
class DriverHomeState extends Equatable {
  final DriverHomeStatus? status;
  List<Marker>? marker = [];
  List? studentData = [];
  final Position? location;
  final Position? driverCurrentLocation;
  RunStatus? runStatus;
  DriverHomeState({
    this.status = DriverHomeStatus.loading,
    this.marker = const [],
    this.studentData = const [],
    this.driverCurrentLocation,
    this.location,
    this.runStatus = RunStatus.none,
  });

  @override
  List<Object?> get props => [status, marker, studentData, location, runStatus, driverCurrentLocation];

  DriverHomeState copyWith({
    DriverHomeStatus? status,
    List<Marker>? marker,
    List? studentData,
    Position? location,
    Position? driverCurrentLocation,
    RunStatus? runStatus,
  }) {
    return DriverHomeState(
      status: status ?? this.status,
      marker: marker ?? this.marker,
      studentData: studentData ?? this.studentData,
      location: location ?? this.location,
      driverCurrentLocation: driverCurrentLocation ?? this.driverCurrentLocation,
      runStatus: runStatus ?? this.runStatus,
    );
  }
}
