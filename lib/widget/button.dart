// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:utility_warehouse/widget/textView.dart';

// class Button extends StatelessWidget {

//   Widget child;
//   Key key;
//   bool loading, disable;
//   VoidCallback onTap;

//   Button({this.child, this.onTap, this.key, this.loading = false, this.disable = false});

//   @override
//   Widget build(BuildContext context){
//     if(loading) {
//       onTap = (){};
//     }
//     return ElevatedButton(
//       key: key,
//       onPressed: disable ? null : onTap,
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.zero,
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10)
//         )
//       ),
//       child: loading ?
//         // Container(
//         //   width: 40,
//         //   height: 20,
//         //   child: Lottie.asset('assets/illustration/loader.json', width: 40, height: 20, fit: BoxFit.contain)
//         // )
//         null
//         :
//         Ink(
//           decoration: BoxDecoration(
//             color: disable ? Colors.grey : null,
//             gradient: disable ? null : LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [Color(0xFF1A2980), Color(0xFF3476aa), Color(0xFF26D0CE)]
//             ),
//             borderRadius: BorderRadius.circular(10)
//           ),
//           child: Container(
//             padding: EdgeInsets.all(12),
//             alignment: Alignment.center,
//             child: child,
//           ),
//         ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:utility_warehouse/widget/textView.dart';

class Button extends StatelessWidget {

  Widget child;
  Key key;
  bool loading, disable;
  VoidCallback onTap;

  Button({this.child, this.onTap, this.key, this.loading = false, this.disable = false});

  @override
  Widget build(BuildContext context){
    if(loading) {
      onTap = (){};
    }
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF1A2980), Color(0xFF3476aa), Color(0xFF26D0CE)]
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
              blurRadius: 1) //blur radius of shadow
          ]
      ),
      child: ElevatedButton(
        key: key,
        onPressed: disable ? null : onTap,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onSurface: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.all(14),
        ),
        child: loading ?
          null
          :
          child
      ),
    );
  }
}
