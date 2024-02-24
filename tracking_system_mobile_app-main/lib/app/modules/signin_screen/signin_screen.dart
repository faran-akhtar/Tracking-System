import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../utils/utils_export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignInCubit(context),
        child: BlocConsumer<SignInCubit, SignInState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'UOG Bus Tracking System',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
                elevation: 0,
              ),
              body: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 20),
                      _buildSignInButton(),
                    ],
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            switch (state.authStatus) {
              case AuthStatus.success:
                Helpers.showToast(
                  context: context,
                  title: state.authMessage,
                );
                break;
              case AuthStatus.failed:
                Helpers.showToast(
                  context: context,
                  title: state.authMessage,
                );
                break;
              default:
            }
          },
        ));
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email',
        focusedBorder: inputBorder(),
        enabledBorder: inputBorder(),
        border: inputBorder(),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      style:
          const TextStyle(color: Colors.black), // Set the text color to black.
    );
  }

  Widget _buildPasswordField() {
    // Add this variable to keep track of the obscured state.

    return TextFormField(
      controller: _passwordController,
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        border: inputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: inputBorder(),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        suffixIcon: GestureDetector(
          // Add a gesture detector to handle the eye button toggle.
          onTap: () {
            setState(() {
              _isObscured = !_isObscured; // Toggle the obscured state.
            });
            print("$_isObscured");
          },
          child: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue,
          ),
        ),
      ),
      obscureText:
          _isObscured, // Use the _isObscured variable to toggle obscureText.
      style:
          const TextStyle(color: Colors.black), // Set the text color to black.
    );
  }

  OutlineInputBorder inputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    );
  }

  Widget _buildSignInButton() {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    bool isEnabled = isFormValid &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;

    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return OutlinedButton(
          onPressed: isEnabled
              ? () {
                  var cubit = context.read<SignInCubit>();
                  if (_formKey.currentState!.validate()) {
                    cubit.onLoginPressed(
                        email: _emailController.text,
                        password: _passwordController.text);
                  }
                }
              : null,
          style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: Colors.blue)),
          ),
          child: Text(
            'Sign In',
            style: TextStyle(color: isEnabled ? Colors.blue : Colors.grey),
          ),
        );
      },
    );
  }

  void _signIn() {
    // Implement your sign-in logic here.
    // For example, show a success message or navigate to the next screen.
  }
}
