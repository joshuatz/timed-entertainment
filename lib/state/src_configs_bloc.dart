import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timed_entertainment/helpers/state_helpers.dart';
import 'package:timed_entertainment/models/sources.dart';

enum srcConfigActions {
    UPDATE,
    DELETE,
    CREATE
}

// typedef is only for functions, so this is so I can specify combo of eventype + class instance as event input for Bloc
class SrcConfigChange {
    srcConfigActions action;
    BaseSourceConfig config;
}

/**
 * This Bloc essentially holds and controls the list of all loaded "source configs" - e.i. configurations for where the media gets pulled from
 */
class ActiveSourceConfigListBloc extends Bloc<SrcConfigChange,Map> {

    void loadFromStorage(){
        // @TODO
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
        yield currentState;
    }

    @override
    void dispose(){
        // @TODO
        super.dispose();
    }
}