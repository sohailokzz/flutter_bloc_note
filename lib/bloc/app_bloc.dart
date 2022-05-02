import 'package:bloc_note_app/apis/login_api.dart';
import 'package:bloc_note_app/apis/notes_api.dart';
import 'package:bloc_note_app/bloc/actions.dart';
import 'package:bloc_note_app/bloc/app_state.dart';
import 'package:bloc_note_app/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //start loading
        emit(
          const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchNotes: null,
          ),
        );
        //log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(
          AppState(
            isLoading: false,
            loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchNotes: null,
          ),
        );

        on<LoadNotesAction>(
          (event, emit) async {
            emit(
              AppState(
                isLoading: true,
                loginErrors: null,
                loginHandle: state.loginHandle,
                fetchNotes: null,
              ),
            );
            final loginHandle = state.loginHandle;
            if (loginHandle != const LoginHandle.foobar()) {
              emit(
                AppState(
                  isLoading: false,
                  loginErrors: LoginErrors.invalidHandle,
                  loginHandle: loginHandle,
                  fetchNotes: null,
                ),
              );
              return;
            }

            final notes = await notesApi.getNotes(
              loginHandle: loginHandle!,
            );
            emit(
              AppState(
                isLoading: false,
                loginErrors: null,
                loginHandle: loginHandle,
                fetchNotes: notes,
              ),
            );
          },
        );
      },
    );
  }
}
