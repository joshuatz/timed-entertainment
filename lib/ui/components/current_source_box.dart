import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';
import 'package:timed_entertainment/ui/components/source_box.dart';

class CurrentSourceBox extends StatelessWidget {
    final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();
    final UserSettingsHasSelectedSrcConfigBloc _hasSelectedConfigBloc = UserSettingsHasSelectedSrcConfigBloc();
    final UserSettingsSelectedSrcConfig _selectedSrcConfigBloc = UserSettingsSelectedSrcConfig();

    @override
    Widget build(BuildContext context){
        return BlocProviderTree(
            blocProviders: [
                BlocProvider<UserSettingsHasSelectedSrcConfigBloc>(bloc: _hasSelectedConfigBloc)
            ],
            child: BlocBuilder(
                bloc: _hasSelectedConfigBloc,
                builder: (BuildContext context,bool hasSelected){
                    return BlocBuilder(
                        bloc: _selectedSrcConfigBloc,
                        builder: (BuildContext context,BaseSourceConfig config){
                            return Container(
                                // width: MediaQuery.of(context).size.width * 1,
                                child: hasSelected ? this.buildInner(config) : this.buildNoSelectedPlaceholder()
                            );
                        }
                    );
                },
            )
        );
    }

    Widget buildInner(BaseSourceConfig config){
        return Container(
            child: SrcBox(
                srcConfig: config,
            ),
        );
    }

    Widget buildNoSelectedPlaceholder(){
        return Container(
            child: Text("No Source Selected")
        );
    }
}