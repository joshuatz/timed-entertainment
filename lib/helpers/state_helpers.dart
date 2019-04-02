import 'dart:convert';
import 'package:timed_entertainment/helpers/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {

    static loadFromStorage<T>(Bloc blocClass,String storageKey){
        SharedPreferences.getInstance().then((prefs){
            dynamic parsedPref;
            var unparsedPref = prefs.get(storageKey);
            if (T==Duration){
                // Durations should have been stored as int of smallest type - microseconds
                int _microseconds = unparsedPref==String ? int.parse(unparsedPref) :unparsedPref;
                parsedPref = Duration(microseconds: _microseconds);
            }
            else if (T==Map){
                parsedPref = jsonDecode(unparsedPref);
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

    static saveToStorage<T>(Bloc blocClass,String storageKey){
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
                else if (T==List){
                    prefs.setStringList(storageKey,blocClass.currentState);
                }
                else if (T==Map){
                    prefs.setString(storageKey,jsonEncode(blocClass.currentState));
                }
                else {
                    try {
                        String sblob =blocClass.currentState.toString();
                        prefs.setString(storageKey, sblob);
                    } catch (e) {
                        print("Could not save to storage");
                    }
                }
            }
        }).catchError((err){
            print(err);
        });
    }
}

// class StorageBloc<E,S> extends Bloc<E,S>{
    
// }