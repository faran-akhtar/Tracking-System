import 'package:flutter/material.dart';
import 'package:tracking_system_mobile_app/app/routes/route_constant.dart';
import '../modules/modules.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
        );
      case Routes.signin:
        return MaterialPageRoute(
          builder: (_) => SignInScreen(),
        );
      case Routes.driverHomeScreen:
        return MaterialPageRoute(
          builder: (_) => DriverHomeScreen(),
        );
      case Routes.studentHomeScreen:
        return MaterialPageRoute(
          builder: (_) => StudentHome(),
        );
      case Routes.studentAttendanceScreen:
        return MaterialPageRoute(
          builder: (_) => StudentAttendanceScreen(),
        );
      case Routes.studentProfileScreen:
        return MaterialPageRoute(
          builder: (_) => StudentProfile(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
