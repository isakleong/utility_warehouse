import 'package:flutter/material.dart';
import 'package:utility_warehouse/settings/configuration.dart';

class TextView extends StatelessWidget{
  Key key;
  String text, fontFamily;
  double fontSize, fontSizeUsed;
  FontWeight fontWeight, fontWeightUsed;
  Color color;
  TextAlign align;
  int type;
  bool caps;

  TextView(this.text, this.type, {this. key, this.fontSize, this.fontWeight, this.color, this.align = TextAlign.left, this.caps = false});

  @override
  Widget build(BuildContext context){
    double space = 0;

    switch(type) {
      case 1:
        this.fontSizeUsed = 22;
        this.fontFamily = 'Roboto';
        this.fontWeightUsed = FontWeight.w700;
      break;
      case 2:
        this.fontSizeUsed = 20;
        this.fontFamily = 'Roboto';
        this.fontWeightUsed = FontWeight.w700;
      break;
      case 3:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 16;
        this.fontWeightUsed = FontWeight.w600;
      break;
      case 4:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 16;
        this.fontWeightUsed = FontWeight.w500;
      break;
      case 5:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 14;
        this.fontWeightUsed = FontWeight.w600;
      break;
      case 6:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 14;
        this.fontWeightUsed = FontWeight.w500;
      break;
      case 7:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 12;
        this.fontWeightUsed = FontWeight.w600;
      break;
      case 8:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 12;
        this.fontWeightUsed = FontWeight.w600;
      break;
      case 9:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 10;
        this.fontWeightUsed = FontWeight.w500;
      break;
      case 10:
        this.fontFamily = 'Roboto';
        this.fontSizeUsed = 8;
        this.fontWeightUsed = FontWeight.w500;
      break;
    }
    
    if (caps && this.text != "") this.text = this.text.toUpperCase();
    if (fontSize != null) this.fontSizeUsed = this.fontSize;
    if (fontWeight != null) this.fontWeightUsed = this.fontWeight;

    return Text(
      this.text,
      key: this.key,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: this.color,
        fontFamily: this.fontFamily,
        fontWeight: this.fontWeightUsed,
        fontSize: this.fontSizeUsed,
        letterSpacing: space,
        height: 1.3,
      ),
      textAlign: this.align,
      maxLines: 9999999,
    );
    
  } 
  
}