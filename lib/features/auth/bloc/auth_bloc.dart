import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/auth/models/society_model.dart';

import '../../../utils/api_error.dart';
import '../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthRegisterLoading());
      try {
        final response = await _authRepository.signUpUser(
            userName: event.userName,
            email: event.email,
            password: event.password,
            confirmPassword: event.confirmPassword);
        emit(AuthRegisterSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthRegisterFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthRegisterFailure(message: e.toString()));
        }
      }
    });

    on<AuthSignIn>((event, emit) async {
      emit(AuthLoginLoading());
      try {
        final GetUserModel response = await _authRepository.signInUser(
            email: event.email, password: event.password);
        emit(AuthLoginSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthLoginFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthLoginFailure(message: e.toString()));
        }
      }
    });

    on<AuthForgotPassword>((event, emit) async {
      emit(AuthForgotPassLoading());
      try {
        final Map<String, dynamic> response =
            await _authRepository.forgotPassword(email: event.email);
        emit(AuthForgotPassSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthForgotPassFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthForgotPassFailure(message: e.toString()));
        }
      }
    });

    on<AuthGoogleSigning>((event, emit) async {
      emit(AuthGoogleSigningLoading());
      try {
        final GetUserModel response = await _authRepository.googleSigning();
        emit(AuthGoogleSigningSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthGoogleSigningFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthGoogleSigningFailure(message: e.toString()));
        }
      }
    });

    on<AuthGoogleLinked>((event, emit) async {
      emit(AuthGoogleLinkedLoading());
      try {
        final Map<String, dynamic> response =
            await _authRepository.googleLinked();
        emit(AuthGoogleLinkedSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthGoogleLinkedFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthGoogleLinkedFailure(message: e.toString()));
        }
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLogoutLoading());
      try {
        final Map<String, dynamic> response =
            await _authRepository.logoutUser();
        emit(AuthLogoutSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthLogoutFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthLogoutFailure(message: e.toString()));
        }
      }
    });

    on<AuthGetUser>((event, emit) async {
      emit(AuthGetUserLoading());
      try {
        // Check for internet first
        bool hasInternet = await _checkInternetConnection();
        if (!hasInternet) {
          emit(AuthGetUserFailure(
              message: "No internet connection",
              errorType: AuthErrorType.noInternet
          ));
          return;
        }

        final GetUserModel response = await _authRepository.getUser();
        emit(AuthGetUserSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          if (e.statusCode == 401) {
            emit(AuthGetUserFailure(
                message: e.message.toString(),
                status: e.statusCode,
                errorType: AuthErrorType.unauthorized
            ));
          } else if (e.statusCode != null && e.statusCode! >= 500) {
            emit(AuthGetUserFailure(
                message: e.message.toString(),
                status: e.statusCode,
                errorType: AuthErrorType.serverError
            ));
          } else {
            emit(AuthGetUserFailure(
                message: e.message.toString(),
                status: e.statusCode,
                errorType: AuthErrorType.unexpectedError
            ));
          }
        } else if (e is SocketException || e.toString().contains('SocketException')) {
          emit(AuthGetUserFailure(
              message: "No internet connection",
              errorType: AuthErrorType.noInternet
          ));
        } else {
          emit(AuthGetUserFailure(
              message: e.toString(),
              errorType: AuthErrorType.unexpectedError
          ));
        }
      }
    });

    on<AuthCompleteProfile>((event, emit) async {
      emit(AuthCompleteProfileLoading());
      try {
        final GetUserModel response = await _authRepository.addCompleteProfile(
            phoneNo: event.phoneNo,
            profileType: event.profileType,
            societyName: event.societyName,
            blockName: event.blockName,
            apartment: event.apartment,
            ownershipStatus: event.ownershipStatus,
            gateName: event.gateName,
            startDate: event.startDate,
            endDate: event.endDate,
            tenantAgreement: event.tenantAgreement,
            ownershipDocument: event.ownershipDocument
        );
        emit(AuthCompleteProfileSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthCompleteProfileFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthCompleteProfileFailure(message: e.toString()));
        }
      }
    });

    on<AuthAddApartment>((event, emit) async {
      emit(AuthAddApartmentLoading());
      try {
        final Map<String, dynamic> response =
            await _authRepository.addApartment(
                societyName: event.societyName,
                societyBlock: event.societyBlock,
                apartment: event.apartment,
                role: event.role);
        emit(AuthAddApartmentSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthAddApartmentFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthAddApartmentFailure(message: e.toString()));
        }
      }
    });

    on<AuthAddGate>((event, emit) async {
      emit(AuthAddGateLoading());
      try {
        final Map<String, dynamic> response = await _authRepository.addGate(
            societyName: event.societyName, gateAssign: event.gateAssign);
        emit(AuthAddGateSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthAddGateFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthAddGateFailure(message: e.toString()));
        }
      }
    });

    on<AuthUpdateFCM>((event, emit) async {
      emit(AuthUpdateFCMLoading());
      try {
        final Map<String, dynamic> response =
            await _authRepository.updateFCM(FCMToken: event.FCMToken);
        emit(AuthUpdateFCMSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthUpdateFCMFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthUpdateFCMFailure(message: e.toString()));
        }
      }
    });

    on<AuthSocietyDetails>((event, emit) async {
      emit(AuthSocietyDetailsLoading());
      try {
        final List<Society> response =
            await _authRepository.getSocietyDetails();
        emit(AuthSocietyDetailsSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthSocietyDetailsFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthSocietyDetailsFailure(message: e.toString()));
        }
      }
    });

    on<AuthGetContactEmail>((event, emit) async {
      emit(AuthGetContactEmailLoading());
      try {
        final Map<String, dynamic> response =
        await _authRepository.getContactEmail();
        emit(AuthGetContactEmailSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AuthGetContactEmailFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AuthGetContactEmailFailure(message: e.toString()));
        }
      }
    });
  }

  AuthState getLatestState() {
    return state;
  }
}

Future<bool> _checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}