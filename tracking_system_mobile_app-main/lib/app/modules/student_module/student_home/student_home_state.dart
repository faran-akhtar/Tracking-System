// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
enum StudentHomeStatus {
  none,
  loading,
  loaded,
  updated,
}

// ignore: must_be_immutable
class StudentHomeState extends Equatable {
  final StudentHomeStatus? status;
  final Position? studentCurrentLocation;
  String? busDocumentId;
  double? busLatitude;
  double? busLongtitude;
  String? distance;
  String? timeDuration;
  StudentHomeState({
    this.status = StudentHomeStatus.loading,
    this.studentCurrentLocation,
    this.busDocumentId,
    this.busLatitude,
    this.busLongtitude,
    this.distance,
    this.timeDuration,
  });

  @override
  List<Object?> get props => [
        status,
        studentCurrentLocation,
        busDocumentId,
        busLatitude,
        busLongtitude,
        distance,
        timeDuration
      ];

 

 

  StudentHomeState copyWith({
    StudentHomeStatus? status,
    Position? studentCurrentLocation,
    String? busDocumentId,
    double? busLatitude,
    double? busLongtitude,
    String? distance,
    String? timeDuration,
  }) {
    return StudentHomeState(
      status: status ?? this.status,
      studentCurrentLocation: studentCurrentLocation ?? this.studentCurrentLocation,
      busDocumentId: busDocumentId ?? this.busDocumentId,
      busLatitude: busLatitude ?? this.busLatitude,
      busLongtitude: busLongtitude ?? this.busLongtitude,
      distance: distance ?? this.distance,
      timeDuration: timeDuration ?? this.timeDuration,
    );
  }
}
