import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
class UserSettingsAllowRepeatsBloc extends Bloc<void,bool> {
    @override
    bool get initialState => false;

    @override
    Stream<bool> mapEventToState(void event) async* {
        yield !currentState;
    }
    @override
    void dispose(){
        // @TODO close out
        super.dispose();
    }
}