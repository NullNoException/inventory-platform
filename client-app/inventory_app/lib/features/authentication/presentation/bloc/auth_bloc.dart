import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<GetCurrentUserRequested>(_onGetCurrentUserRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _getCurrentUserUseCase();

    result.fold((failure) => emit(const Unauthenticated()), (user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signInUseCase(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signUpUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(RegistrationSuccess(user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signOutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _resetPasswordUseCase(email: event.email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(PasswordResetSent(event.email)),
    );
  }

  Future<void> _onGetCurrentUserRequested(
    GetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _getCurrentUserUseCase();

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }
}
