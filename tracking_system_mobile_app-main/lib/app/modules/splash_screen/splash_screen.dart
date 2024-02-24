import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_system_mobile_app/app/routes/routes_export.dart';

import '../../../animations/leftRightFadeInAnimation.dart';
import '../driver_module/driver_module_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocationServiceRepository locationRepository =
      LocationServiceRepository();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      if (await Permission.locationAlways.isGranted) {
        return true;
      } else {
        final result = await openAppSettings();
        return result;
      }
    } else if (permissionStatus == PermissionStatus.denied) {
      Permission.location.request();
      return false;
    }
    return false;
  }

  void _navigateToNextScreen() async {
    final permission = await checkLocationPermission();
    if (permission) {
      await Future.delayed(const Duration(seconds: 3));
      // ignore: use_build_context_synchronously
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.onboarding);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Give location permission')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: LeftToRightFadeInWidget(
          duration: const Duration(milliseconds: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'UOG Bus Tracking System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
