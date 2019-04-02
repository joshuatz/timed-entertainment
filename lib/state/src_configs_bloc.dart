import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timed_entertainment/helpers/state_helpers.dart';
import 'package:timed_entertainment/models/sources.dart';

enum srcConfigActions {
    UPDATE,
    DELETE,
    CREATE,
    RESETALL
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

    static final ActiveSourceConfigListBloc _instance = new ActiveSourceConfigListBloc._internal();

    factory ActiveSourceConfigListBloc(){
        return _instance;
    }

    ActiveSourceConfigListBloc._internal();

    static const String _storageKey = "activeSourceConfigList";

    void loadFromStorage(){
        SettingsStorage.loadFromStorage<Map>(this, _storageKey);
    }

    void saveToStorage(){
        SettingsStorage.saveToStorage<Map>(this, _storageKey);
    }

    void reset(){
        this.dispatch(SrcConfigChange(action: srcConfigActions.RESETALL,config: null));
    }

    @override
    Map<int,BaseSourceConfig> get initialState {
        // @TODO
        var fakeMap = {
            25 : BaseSourceConfig.mock(2,sourceEnum.YOUTUBE)
        };
        return fakeMap;
    }

    @override
    Stream<Map> mapEventToState(SrcConfigChange event) async* {
        // @TODO
        if (event.action==srcConfigActions.DELETE){
            currentState.remove(event.config.configId);
        }
        else if (event.action==srcConfigActions.UPDATE){
            // @TODO
        }
        else if (event.action==srcConfigActions.CREATE){
            // @TODO
            // Will have a new ID
            event.config.configId = currentState.length > 0 ? (currentState.keys.last + 1) : 1;
            // Save it to state
            currentState[event.config.configId] = event.config;
        }
        else if(event.action==srcConfigActions.RESETALL){
            currentState.clear();
        }
        yield currentState;
    }

    @override
    void dispose(){
        print('src_configs_bloc dispose');
        // @TODO
        super.dispose();
    }

}