import 'package:bloc_note_app/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchNotes;

  const AppState.empty()
      : isLoading = false,
        loginErrors = null,
        loginHandle = null,
        fetchNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchNotes,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginErrors': loginErrors,
        'loginHandle': loginHandle,
        'fetchNotes': fetchNotes
      }.toString();
}
