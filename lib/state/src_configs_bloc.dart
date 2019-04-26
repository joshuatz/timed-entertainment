import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timed_entertainment/helpers/state_helpers.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';

enum srcConfigActions {
    UPDATE,
    DELETE,
    CREATE,
    RESETALL,
    UPDATEFROMSTORAGE
}

// typedef is only for functions, so this is so I can specify combo of eventype + class instance as event input for Bloc
class SrcConfigChange {
    srcConfigActions action;
    BaseSourceConfig config;
    SrcConfigChange({this.action,this.config});
}



/**
 * This Bloc essentially holds and controls the list of all loaded "source configs" - e.i. configurations for where the media gets pulled from
 */
class ActiveSourceConfigListBloc extends Bloc<SrcConfigChange,Map> {

    static final UserSettingsHasSelectedSrcConfigBloc hasSelectedConfigBloc = new UserSettingsHasSelectedSrcConfigBloc();
    static final UserSettingsSelectedSrcConfig selectedSrcConfigBloc = new UserSettingsSelectedSrcConfig();

    static final ActiveSourceConfigListBloc _instance = new ActiveSourceConfigListBloc._internal();

    factory ActiveSourceConfigListBloc(){
        return _instance;
    }

    ActiveSourceConfigListBloc._internal();

    static const String _storageKey = "activeSourceConfigList";

    void loadFromStorage(){
        // Trigger getFromStorage by dispatching event
        this.dispatch(SrcConfigChange(
            action: srcConfigActions.UPDATEFROMSTORAGE,
            config: BaseSourceConfig()
        ));
    }

    Future<Map<int,BaseSourceConfig>> getFromStorage() async {
        // Do this by hand rather than using helper method, since saved in odd format
        return SharedPreferences.getInstance().then((prefs){
            var unparsedConfigs = prefs.get(_storageKey);
            if (unparsedConfigs!="" && unparsedConfigs!=null){
                print(unparsedConfigs is String);
                // Construct an ID based map from the stored
                Map<int,BaseSourceConfig> unencodedMap = Map<int,BaseSourceConfig>();
                Map<String,dynamic> encodedMap = Map<String,dynamic>();
                try {
                    encodedMap = jsonDecode(unparsedConfigs);
                    encodedMap.forEach((key,val){
                        unencodedMap[int.parse(key)] = BaseSourceConfig().fromJson(val);
                    });
                    return unencodedMap;
                } catch (e) {
                    print(unparsedConfigs);
                    print(e);
                    return initialState;
                }
                
            }
        });
    }

    void saveToStorage(){
        print("Saving out source configs to storage");
        // Convert currentState into a more encodable format...
        Map<String,Map> preEncodedState = Map<String,Map>();
        this.currentState.forEach((key, config){
            preEncodedState[key.toString()] = config.toJson();
        });
        SettingsStorage.saveToStorage<Map<String,Map>>(this,preEncodedState,_storageKey);
    }

    void reset(){
        this.dispatch(SrcConfigChange(action: srcConfigActions.RESETALL,config: null));
    }

    @override
    Map<int,BaseSourceConfig> get initialState {
        // @TODO
        Map<int,BaseSourceConfig> fakeMap = Map<int,BaseSourceConfig>();
        // var fakeMap = {
        //     25 : BaseSourceConfig.mock(25,sourceEnum.YOUTUBE)
        // };
        return fakeMap;
    }

    

    @override
    Stream<Map<int,BaseSourceConfig>> mapEventToState(SrcConfigChange event) async* {
        // @TODO
        // var _updatedState = currentState;
        var _updatedState = Map<int,BaseSourceConfig>.from(currentState);
        if (event.action==srcConfigActions.DELETE){
            _updatedState.remove(event.config.configId);
            // If that was the last config we just deleted, unset selected srcConfig
            if (_updatedState.length==0){
                hasSelectedConfigBloc.dispatch(false);
            }
        }
        else if (event.action==srcConfigActions.UPDATE){
            print(event.config.userDefinedName);
            if (_updatedState.containsKey(event.config.configId)){
                _updatedState.update(event.config.configId, (BaseSourceConfig config){return event.config;});
            }
        }
        else if (event.action==srcConfigActions.CREATE){
            var isOnlyConfig = currentState.length == 0;
            // Will have a new ID
            event.config.configId = _updatedState.length > 0 ? (_updatedState.keys.last + 1) : 1;
            // Save it to state
            _updatedState[event.config.configId] = event.config;
            // If this is now the only config, set it as the selected config
            if (isOnlyConfig){
                selectedSrcConfigBloc.dispatch(event.config.configId);
                hasSelectedConfigBloc.dispatch(true);
            }
        }
        else if(event.action==srcConfigActions.RESETALL){
            _updatedState.clear();
            hasSelectedConfigBloc.dispatch(false);
        }
        else if(event.action == srcConfigActions.UPDATEFROMSTORAGE){
            _updatedState = await getFromStorage();
        }
        yield _updatedState;
    }

    @override
    void dispose(){
        print('src_configs_bloc dispose');
        // @TODO
        super.dispose();
    }

}