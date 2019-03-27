import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserSettingsAllowRepeatsBloc extends Bloc<void,bool> {
    static const String _storageKey = "UserSettingsAllowRepeats";

    void loadFromStorage(){
        SharedPreferences.getInstance().then((prefs){
            bool pref = prefs.getBool(_storageKey);
            if (pref != currentState) {
                dispatch(VoidFunc);
            }
        }).catchError((err){
            print(err);
        });
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
        SharedPreferences.getInstance().then((prefs){
            bool pref = prefs.getBool(_storageKey);
            if (pref != currentState) {
                prefs.setBool(_storageKey, currentState);
            }
        }).catchError((err){
            print(err);
        });
        // @TODO close out
        super.dispose();
    }
}