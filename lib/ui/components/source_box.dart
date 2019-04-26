import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/ui/pages/source_editor.dart';

class SrcBox extends StatelessWidget {
	final BaseSourceConfig srcConfig;
	final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();
	SrcBox({Key key,@required this.srcConfig}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		SourceMeta sourceMeta = SourceMeta(srcConfig.sourceType); 
		String _displayName = srcConfig.hasUserDefinedName ? srcConfig.userDefinedName : ("Config ID #" + srcConfig.configId.toString());
		String _sourceName = sourceMeta.displayName;
		return Card(
			margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
			elevation: 10,
			child: Container(
				padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
				// Row is main container
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: <Widget>[
						// Left side is split into two rows
						Column(
							children: <Widget>[
								// Top of left side should be #ID and source type
								IntrinsicHeight(
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											// left side of top row
											Container(
												padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
												decoration: BoxDecoration(
													border: new Border.all(
														color: Colors.black,
													),
												),
												child: Row(
													children: <Widget>[
														Text(
															"[" + srcConfig.configId.toString() + "]",
															style: TextStyle(
																fontSize: 10
															),
														),
													],
												),
											),
                                            Container(
                                                width: 2,
                                                decoration: BoxDecoration(
                                                    color: Colors.black54
                                                ),
                                            ),
											// Right side of top row
											Container(
												padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
												decoration: BoxDecoration(
													border: new Border.all(color: Colors.black),
												),
												child: Row(
													// mainAxisAlignment: MainAxisAlignment.spaceAround,
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: <Widget>[
														sourceMeta.icon,
														Container(
															width: 10,
														),
														Text(_sourceName),
													],
												),
											),
										],
									),
								),
								// Bottom of left side should just be the name
								Row(
									children: <Widget>[
										Container(
											padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
											child: Text(_displayName),
										),
									],
								)
							],
						),
						// Right side is single row, full height
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: <Widget>[
								IconButton(
									iconSize: 20,
									color: Colors.redAccent.shade200,
									icon: Icon(Icons.delete),
									onPressed: ()=>{
										// @TODO ask for confirm, then delete source
										// Use AlertDialog?
										showDialog(
											context: context,
											builder: (BuildContext context){
												return AlertDialog(
													title: Text('Are you sure?'),
													content: Text('This will delete the source for ever'),
													actions: <Widget>[
														FlatButton(
															child: Text('Cancel'),
															onPressed: (){
																Navigator.of(context).pop();
															},
														),
														FlatButton(
															child: Text('DELETE',style: TextStyle(color: Colors.red),),
															onPressed: (){
																_srcConfigBloc.dispatch(SrcConfigChange(
																	action: srcConfigActions.DELETE,
																	config:srcConfig
																));
																Navigator.of(context).pop();
															},
														)
													],
												);
											}
										)
									},
								),
								Container(
									// height: MediaQuery.of(context).size.height,
									height: 40,
									width: 2,
									color: Colors.black,
									margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
								),
								IconButton(
									iconSize: 20,
									icon : Icon(Icons.edit),
									tooltip: "Edit",
									onPressed: (){
										Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SourceEditorPage(
                                                isExistingConfig: true,
                                                config: srcConfig,
                                            ))
                                        );
									},
								),
							],
						),
					],
				),
			),
		);
	}
}