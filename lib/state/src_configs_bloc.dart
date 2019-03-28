import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timed_entertainment/helpers/state_helpers.dart';
import 'package:timed_entertainment/models/sources.dart';

enum srcConfigActions {
    UPDATE,
    DELETE,
    CREATE
}

// class SourceConfigListBloc extends Bloc<srcConfigActions,dynamic> {
//     //
// }