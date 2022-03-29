import 'package:flutter/material.dart';

class TextView extends StatelessWidget{
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color color;

  TextView({this.text, this.fontSize = 18,  this.fontWeight, this.color});
  // TextView(this.text, this.fontSize, this.fontWeight);

  @override
  Widget build(BuildContext context) {
    return Text(
      text, style: TextStyle(fontSize: this.fontSize, fontWeight: this.fontWeight, color: this.color),
    );
  }
}