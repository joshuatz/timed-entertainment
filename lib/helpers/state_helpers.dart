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

    static saveToStorage<T>(Bloc blocClass,dynamic state,String storageKey){
        SharedPreferences.getInstance().then((prefs){
            var pref = prefs.get(storageKey);
            if (pref != state) {
                // Note - "is" does not work for type checking of generic method
                if (T==bool){
                    prefs.setBool(storageKey, state);
                }
                else if (T==String){
                    prefs.setString(storageKey,state);
                }
                else if (T==int){
                    prefs.setInt(storageKey, state);
                }
                else if (T==double){
                    prefs.setDouble(storageKey, state);
                }
                else if (T==Duration){
                    // print(state.inMicroseconds);
                    prefs.setInt(storageKey,state.inMicroseconds);
                }
                else if (T==List){
                    prefs.setStringList(storageKey,state);
                }
                else if (T==Map || state is Map){
                    print(state);
                    print(jsonEncode(state));
                    prefs.setString(storageKey,'' + jsonEncode(state) + '');
                }
                else {
                    print("SettingsStorage.saveToStorage - could not detect type");
                    print(T);
                    try {
                        String sblob =state.toString();
                        prefs.setString(storageKey, sblob);
                    } catch (e) {
                        print("Could not save to storage");
                    }
                }
            }
        }).catchError((err){
            print("Error encoding state to JSON");
            print(T);
            print(err);
        });
    }
}

// class StorageBloc<E,S> extends Bloc<E,S>{
    
// }