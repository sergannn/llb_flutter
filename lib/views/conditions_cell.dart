import 'package:flutter/material.dart';

class ConditionsCell extends StatelessWidget {
  final condition;

  ConditionsCell(this.condition);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(8.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
           //   new Image.network(video["imageUrl"]),
              new Container(
                height: 1.0,
              ),
              new Text(
                condition
                //condition.parent.text
              ),
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
