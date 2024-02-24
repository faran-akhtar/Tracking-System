import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_system_mobile_app/app/routes/routes_export.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select Your Role',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton('Student'),
                      const SizedBox(width: 20),
                      _buildButton('Driver'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
                alignment: Alignment.bottomRight, child: _buildArrowButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String role) {
    bool isSelected = selectedRole == role;

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          selectedRole = role;
        });
        SharedPreferences sharedP = await SharedPreferences.getInstance();
        if (sharedP.getString('role') != null) {
          sharedP.remove('role');
        }
        sharedP.setString('role', selectedRole);

        print(sharedP.getString("role"));
      },
      style: ButtonStyle(
        backgroundColor:
            isSelected ? MaterialStateProperty.all<Color>(Colors.blue) : null,
        shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
        side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.blue)),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.blue,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildArrowButton() {
    return selectedRole.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _navigateToLoginScreen,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueAccent),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    const StadiumBorder()),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          )
        : SizedBox();
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacementNamed(Routes.signin);
  }
}
