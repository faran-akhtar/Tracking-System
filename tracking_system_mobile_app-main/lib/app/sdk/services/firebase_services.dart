import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> markAttendance() async {
    String res = "Some error Occured";

    try {
      final user = firebaseAuth.currentUser;

      final location = await _determineLocation();

      final userDocRef =
          FirebaseFirestore.instance.collection('Attendance').doc(user!.uid);

      if (location != null) {
        // Get the latest attendance record
        final documentSnapshot = await userDocRef.get();
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final attendanceList = data['attendanceList'] as List<dynamic>;

          if (attendanceList.isNotEmpty) {
            final latestRecord = attendanceList.last as Map<String, dynamic>;

            if (latestRecord['checkOutTime'] == null) {
              final updatedRecord = {
                ...latestRecord,
                'checkOutTime': Timestamp.now(),
                'checkOutLocation': location,
              };

              attendanceList[attendanceList.length - 1] = updatedRecord;

              userDocRef.update({'attendanceList': attendanceList});

              print("Checked out");
            } else {
              final attendanceRecord = {
                'checkInTime': Timestamp.now(),
                'checkInLocation': location,
              };

              attendanceList.add(attendanceRecord);

              userDocRef.update({'attendanceList': attendanceList});

              print("Checked in");
            }
          }
        } else {
          _createNewCheckIn(userDocRef);
        }
      } else {
        res = 'Please On your gps location';
      }
      res = 'success';
    } on FirebaseException {
      res = 'Some Error Occred While Uploading data';
    }
    return res;
  }

  void _createNewCheckIn(DocumentReference userDocRef) async {
    final location = await _determineLocation();
    final user = firebaseAuth.currentUser;
    if (location != null) {
      final attendanceRecord = {
        'checkInTime': Timestamp.now(),
        'checkInLocation': location,
        'checkOutLocation': null,
        'checkOutTime': null,
      };

      userDocRef.set(
        {
          'attendanceList': [attendanceRecord],
          'studentUserId': user!.uid
        },
      );

    } else {
    }
  }

  Future<String?> _determineLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return "Lat: ${position.latitude}, Lon: ${position.longitude}";
    } catch (e) {
      print("Error obtaining location: $e");
      return null;
    }
  }
}
