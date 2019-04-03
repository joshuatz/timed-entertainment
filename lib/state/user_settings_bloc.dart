import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timed_entertainment/helpers/state_helpers.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
class UserSettingsAllowRepeatsBloc extends Bloc<void,bool> {
    static const String _storageKey = "UserSettingsAllowRepeats";

    void loadFromStorage(){
        SettingsStorage.loadFromStorage<bool>(this, _storageKey);
    }

    @override
    bool get initialState {return false;}

    @override
    Stream<bool> mapEventToState(void event) async* {
        yield !currentState;
    }

    @override
    void dispose(){
        SettingsStorage.saveToStorage<bool>(this, _storageKey);
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
        SettingsStorage.loadFromStorage<Duration>(this, _storageKey);
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
        SettingsStorage.saveToStorage<Duration>(this, _storageKey);
        super.dispose();
    }
}

class UserSettingsHasSelectedSrcConfigBloc extends Bloc<bool,bool>{
    //
    static final UserSettingsHasSelectedSrcConfigBloc _instance = new UserSettingsHasSelectedSrcConfigBloc._internal();

    UserSettingsHasSelectedSrcConfigBloc._internal();

    factory UserSettingsHasSelectedSrcConfigBloc(){
        return _instance;
    }

    @override
    bool get initialState {
        return false;
    }

    @override
    Stream<bool> mapEventToState(bool event) async* {
        yield event;
    }
}

class UserSettingsSelectedSrcConfig extends Bloc<int,BaseSourceConfig>{
    static final ActiveSourceConfigListBloc activeConfigsListBloc = new ActiveSourceConfigListBloc();
    static final UserSettingsHasSelectedSrcConfigBloc hasSelectedSrcConfigBloc = new UserSettingsHasSelectedSrcConfigBloc();

    static final UserSettingsSelectedSrcConfig _instance = new UserSettingsSelectedSrcConfig._internal();

    UserSettingsSelectedSrcConfig._internal();

    factory UserSettingsSelectedSrcConfig(){
        return _instance;
    }


    static const String _storageKey = "UserSettingsSelectedSrcConfig";

    void loadFromStorage(){
        SettingsStorage.loadFromStorage<bool>(this, _storageKey);
    }

    void saveToStorage(){
        SettingsStorage.saveToStorage<Map>(this, _storageKey);
    }

    @override
    BaseSourceConfig get initialState {
        var fakeConfig = BaseSourceConfig.mock(2,sourceEnum.YOUTUBE);
        return fakeConfig;
    }

    @override
    Stream<BaseSourceConfig> mapEventToState(int event) async* {
        int configId = event;
        // Get full list of available configs
        Map activeConfigs = activeConfigsListBloc.currentState;
        if (activeConfigs.keys.contains(configId)){
            yield activeConfigs[configId];
        }
        else {
            // Something went wrong, and we are trying to select a config that does not exist in the list...
            hasSelectedSrcConfigBloc.dispatch(false);
        }
    }
}