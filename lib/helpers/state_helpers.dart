import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {

    loadFromStorage<T>(Bloc blocClass,String storageKey){
        
        SharedPreferences.getInstance().then((prefs){
            T pref = prefs.get(storageKey);
            if (pref != blocClass.currentState) {
                blocClass.dispatch(pref);
            }
        }).catchError((err){
            print(err);
        });
    }

    saveToStorage<T>(Bloc blocClass,String storageKey){
        SharedPreferences.getInstance().then((prefs){
            T pref = prefs.get(storageKey);
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
            }
        }).catchError((err){
            print(err);
        });
    }
}

// class StorageBloc<E,S> extends Bloc<E,S>{
    
// }