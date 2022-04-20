import 'package:flutter/material.dart';
import 'package:utility_warehouse/settings/configuration.dart';

class TextView extends StatelessWidget{
  String text, fontFamily;
  double fontSize, fontSizeUsed;
  FontWeight fontWeight;
  Color color;
  TextAlign align;
  int type;
  bool caps;

  TextView(this.text, this.type, {this.fontSize, this.fontWeight, this.color, this.align = TextAlign.left, this.caps = false});

  @override
  Widget build(BuildContext context){
    double space = 0;

    switch(type) {
      case 1:
        this.fontSizeUsed = 22;
        this.fontFamily = 'Roboto';
        this.fontWeight = FontWeight.w700;
      break;
      case 2:
        this.fontSizeUsed = 20;
        this.fontFamily = 'Roboto';
        this.fontWeight = FontWeight.w700;
      break;
      case 3:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 16;
        this.fontWeight = FontWeight.w600;
      break;
      case 4:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 16;
        this.fontWeight = FontWeight.w500;
      break;
      case 5:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 14;
        this.fontWeight = FontWeight.w600;
      break;
      case 6:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 14;
        this.fontWeight = FontWeight.w500;
      break;
      case 7:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 12;
        this.fontWeight = FontWeight.w600;
      break;
      case 8:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 12;
        this.fontWeight = FontWeight.w600;
      break;
      case 9:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 10;
        this.fontWeight = FontWeight.w500;
      break;
      case 10:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 8;
        this.fontWeight = FontWeight.w500;
      break;
    }
    
    if (caps && this.text != "") this.text = this.text.toUpperCase();
    if (fontSize != null) this.fontSizeUsed = this.fontSize;

    return Text(
      this.text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: this.color,
        fontFamily: this.fontFamily,
        fontWeight: this.fontWeight,
        fontSize: this.fontSizeUsed,
        letterSpacing: space,
        height: 1.3,
      ),
      textAlign: this.align,
      maxLines: 9999999,
    );
    
  } 
  
}