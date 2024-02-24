import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tracking_system_mobile_app/app/sdk/services/firebase_services.dart';
import '../../../styles/style.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  String? result;

  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _showQRScannerDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan QR Code'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        title: Text(
          'Attendance',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FlutterTextTheme.lightTextTheme.headline4?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 200,
              onPressed: () async {
                _showQRScannerDialog(context);
              },
              icon: const Icon(Icons.qr_code),
            ),
            SizedBox(height: 20),
            result == null
                ? SizedBox.shrink()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.blue.shade600,
                      ),
                    ),
                    onPressed: () async {
                      FirebaseServices services = FirebaseServices();
                      final response = await services.markAttendance();
                      if (response == 'success') {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Successfully Attendance Mark',
                            ),
                          ),
                        );
                        // ignore: use_build_context_synchronously
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error While Marking Attendance',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
