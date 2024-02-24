// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum SignInStatus { loading, loaded }

enum AuthStatus {
  none,
  failed,
  success,
}

class SignInState extends Equatable {
  final SignInStatus status;
  final AuthStatus authStatus;
  final String authMessage;
  final bool loading;

  const SignInState({
    this.status = SignInStatus.loaded,
    this.authStatus = AuthStatus.none,
    this.authMessage = '',
    this.loading = false,
  });

  
  @override
  List<Object?> get props => [status,authStatus,authMessage,loading];

  SignInState copyWith({
    SignInStatus? status,
    AuthStatus? authStatus,
    String? authMessage,
    bool? loading,
  }) {
    return SignInState(
      status: status ?? this.status,
      authStatus: authStatus ?? this.authStatus,
      authMessage: authMessage ?? this.authMessage,
      loading: loading ?? this.loading,
    );
  }
}
