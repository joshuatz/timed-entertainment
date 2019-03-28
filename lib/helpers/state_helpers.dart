import 'dart:convert';
import 'package:timed_entertainment/helpers/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {

    loadFromStorage<T>(Bloc blocClass,String storageKey){
        SharedPreferences.getInstance().then((prefs){
            dynamic parsedPref;
            var unparsedPref = prefs.get(storageKey);
            if (T==Duration){
                // Durations should have been stored as int of smallest type - microseconds
                int _microseconds = unparsedPref==String ? int.parse(unparsedPref) :unparsedPref;
                parsedPref = Duration(microseconds: _microseconds);
            }
            else {
                parsedPref = unparsedPref;
            }
            if (parsedPref != blocClass.currentState) {
                blocClass.dispatch(parsedPref);
            }
        }).catchError((err){
            print(err);
        });
    }

    saveToStorage<T>(Bloc blocClass,String storageKey){
        SharedPreferences.getInstance().then((prefs){
            var pref = prefs.get(storageKey);
            if (pref != blocClass.currentState) {
                // Note - "is" does not work for type checking of generic method
                if (T==bool){
                    prefs.setBool(storageKey, blocClass.currentState);
                }
                else if (T==String){
                    prefs.setString(storageKey,blocClass.currentState);
                }
                else if (T==int){
                    prefs.setInt(storageKey, blocClass.currentState);
                }
                else if (T==double){
                    prefs.setDouble(storageKey, blocClass.currentState);
                }
                else if (T==Duration){
                    // print(blocClass.currentState.inMicroseconds);
                    prefs.setInt(storageKey,blocClass.currentState.inMicroseconds);
                }
            }
        }).catchError((err){
            print(err);
        });
    }
}

// class StorageBloc<E,S> extends Bloc<E,S>{
    
// }