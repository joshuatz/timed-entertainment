import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class UserSettingsBloc {
    // Stream / BehavSrc instantiation
    final _hasFavoriteSource = new BehaviorSubject<bool>.seeded(false);

    // Stream / Observable getters
    Observable get hasFavoriteSourceStream$ => _hasFavoriteSource.stream;

    // Current / single value getters
    bool get currentHasFavoriteSourceStream => _hasFavoriteSource.value;

    // Inputs / setters
    void setHasFavoriteSourceStream(bool val){
        _hasFavoriteSource.add(val);
    }

    // Close out streams
    void dispose(){
        // Save values

        // Close streams
        _hasFavoriteSource.close();
    }
}