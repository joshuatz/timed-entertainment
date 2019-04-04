import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';

class CurrentSourceBox extends StatelessWidget {
    final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();
    final UserSettingsHasSelectedSrcConfigBloc _hasSelectedConfigBloc = new UserSettingsHasSelectedSrcConfigBloc();
    final UserSettingsSelectedSrcConfig _selectedSrcConfigBloc = UserSettingsSelectedSrcConfig();

    @override
    Widget build(BuildContext context){
        return BlocProviderTree(
            blocProviders: [
                BlocProvider<UserSettingsHasSelectedSrcConfigBloc>(bloc: _hasSelectedConfigBloc)
            ],
            child: Builder(
                builder: (BuildContext context){

                    return Container(
                        child: this._hasSelectedConfigBloc.currentState ? this.buildInner(_selectedSrcConfigBloc.currentState) : this.buildNoSelectedPlaceholder()
                    );
                },
            )
        );
    }

    Widget buildInner(BaseSourceConfig config){
        return Container(
            child: Text(config.configId.toString())
        );
    }

    Widget buildNoSelectedPlaceholder(){
        return Container(
            child: Text("No Source Selected")
        );
    }
}