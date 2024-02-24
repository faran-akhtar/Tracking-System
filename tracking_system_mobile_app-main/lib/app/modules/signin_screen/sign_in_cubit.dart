import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app.dart';
import '../../utils/utils_export.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.context) : super(SignInState()) {
    authServices = AuthServices();
  }

  BuildContext context;
  late AuthServices authServices;

  Future<void> onLoginPressed(
      {required String email, required String password}) async {
    emit(state.copyWith(loading: true));
    try {
      var result = await _loginWithOauth(email: email, password: password);

      if (result) {
        SharedPreferences sharedP = await SharedPreferences.getInstance();
        String userRole = sharedP.getString('role').toString();

        if (userRole == "Student") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(
            context,
            Routes.studentHomeScreen,
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(
            context,
            Routes.driverHomeScreen,
          );
        }
      }
    } catch (e) {
      Helpers.showToast(
        context: context,
        title: 'Error occurred while fetching data',
      );
    }
    emit(state.copyWith(loading: false));
  }

  Future<bool> _loginWithOauth(
      {required String email, required String password}) async {
    try {
      emit(state.copyWith(
          authStatus: AuthStatus.none, status: SignInStatus.loading));
      var result = await authServices.signIn(email: email, password: password);
      if (result.contains('success')) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.success,
            status: SignInStatus.loaded,
            authMessage: 'Signed In Scessfully',
          ),
        );
        return true;
      } else if (result.contains('user-not-found')) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failed,
            status: SignInStatus.loaded,
            authMessage: 'No user found for that email.',
            loading: false,
          ),
        );
        return false;
      } else if (result.contains('wrong-password')) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failed,
            status: SignInStatus.loaded,
            authMessage: 'Wrong password provided for that user.',
            loading: false,
          ),
        );
        return false;
      }
      return false;
    } catch (e) {
      emit(
        state.copyWith(
          authStatus: AuthStatus.failed,
          status: SignInStatus.loaded,
          authMessage: 'Error occurred while signing in',
          loading: false,
        ),
      );
      return false;
    }
  }
}
