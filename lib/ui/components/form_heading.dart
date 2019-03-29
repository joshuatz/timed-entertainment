import 'package:flutter/material.dart';

class FormHeading extends StatelessWidget {
    final String title;
    final Color dividerColor;
    final Color titleColor;
    final double titleSize;
    FormHeading({
        Key key,
        @required this.title,
        this.dividerColor : Colors.black45,
        this.titleColor : Colors.black45,
        this.titleSize : 15
    }) : super(key: key);

    Widget buildDivider(BuildContext context){
        return Container(
            decoration: BoxDecoration(color: dividerColor),
            width: MediaQuery.of(context).size.width*1,
            height: 2,
            margin: EdgeInsets.only(
                top: 12,
                bottom: 10
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                buildDivider(context),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        this.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: this.titleSize,
                            fontWeight: FontWeight.bold
                        ),
                    ),
                ),
                buildDivider(context),
            ],
        );
    }
}