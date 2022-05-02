import 'package:bloc_note_app/apis/login_api.dart';
import 'package:bloc_note_app/apis/notes_api.dart';
import 'package:bloc_note_app/bloc/actions.dart';
import 'package:bloc_note_app/bloc/app_bloc.dart';
import 'package:bloc_note_app/bloc/app_state.dart';
import 'package:bloc_note_app/dialogs/generic_dialog.dart';
import 'package:bloc_note_app/dialogs/loading_screen.dart';
import 'package:bloc_note_app/models.dart';
import 'package:bloc_note_app/strings.dart';
import 'package:bloc_note_app/views/iterable_list_view.dart';
import 'package:bloc_note_app/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display error
            final loginError = appState.loginErrors;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }
            //if we are logged in but we have no fetch notes fetch them now
            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.foobar() &&
                appState.fetchNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
