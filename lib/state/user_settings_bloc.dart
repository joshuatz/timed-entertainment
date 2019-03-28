import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timed_entertainment/helpers/state_helpers.dart';
class UserSettingsAllowRepeatsBloc extends Bloc<void,bool> {
    static const String _storageKey = "UserSettingsAllowRepeats";

    void loadFromStorage(){
        SettingsStorage().loadFromStorage<bool>(this, _storageKey);
    }

    @override
    bool get initialState {return false;}

    @override
    Stream<bool> mapEventToState(void event) async* {
        yield !currentState;
    }

    @override
    void dispose(){
        print("DISPOSE TRIGGERED");
        SettingsStorage().saveToStorage<bool>(this, _storageKey);
        super.dispose();
    }
}

class UserSettingsMinElapsedForRepeatBloc extends Bloc<Duration,Duration> {
    static const String _storageKey = "UserSettingsMinElapsedForRepeat";
    @override
    Duration get initialState => Duration(days: 31);

    @override
    Stream<Duration> mapEventToState(Duration event) async* {
        yield event;
    }

    void loadFromStorage(){
        SettingsStorage().loadFromStorage<Duration>(this, _storageKey);
    }

    deductDay(){
        Duration updatedDur = Duration(days: (this.currentState.inDays -1));
        this.dispatch(updatedDur);
    }
    
    addDay(){
        Duration updatedDur = Duration(days: (this.currentState.inDays +1));
        this.dispatch(updatedDur);
    }

    @override
    void dispose(){
        print("DISPOSE TRIGGERED");
        SettingsStorage().saveToStorage<Duration>(this, _storageKey);
        super.dispose();
    }
}