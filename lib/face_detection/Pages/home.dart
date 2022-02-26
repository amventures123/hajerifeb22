// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hajeri/Pages/landing.dart';
// import '../Pages/landing.dart';

// import '../constant.dart';

// class SignUp extends StatefulWidget {
//   static String id = "sign_up";
//   const SignUp({Key key}) : super(key: key);

//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   TextEditingController _cNumber;

//   var _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _cNumber = TextEditingController(text: '1234567890');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.blue[800],
//         centerTitle: true,
//         title: Text(
//           'Validating',
//           textAlign: TextAlign.center,
//         ),
//       ),
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10.0,
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 10.0,
//                 horizontal: 15.0,
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: TextFormField(
//                   controller: _cNumber,
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     if (value.trim().length == 10) {
//                       FocusScope.of(context).requestFocus(
//                         new FocusNode(),
//                       );
//                     }
//                   },
//                   validator: (value) {
//                     if (value.trim().length == 0) {
//                       return "Please Enter Mobile Number";
//                     }
//                     if (value.trim().length > 10 ||
//                         value.trim().length < 10 ||
//                         value.trim().contains(new RegExp(r'[A-Za-z/@_-]'))) {
//                       return "Please Enter Valid Mobile Number";
//                     }
//                     if (value.trim().length == 10) {
//                       FocusScope.of(context).requestFocus(
//                         new FocusNode(),
//                       );
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     prefixText: '+91',
//                     border: OutlineInputBorder(),
//                     labelText: 'Mobile Number',
//                     prefixIcon: Icon(
//                       Icons.phone_android_rounded,
//                     ),
//                     hintText: 'Can I have your number?',
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 10.0,
//                 bottom: 10.0,
//               ),
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                     EdgeInsets.zero,
//                   ),
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                     Colors.transparent,
//                   ),
//                 ),
//                 onPressed: () async {
//                   // ignore: null_aware_in_condition
//                   if (_formKey.currentState.validate()) {
//                     log('form validation successful');
//                     FocusScope.of(context).requestFocus(new FocusNode());
//                     await SystemChannels.textInput
//                         .invokeMethod('TextInput.hide');
//                     Navigator.push(
//                         context, MaterialPageRoute(builder: (_) => Landing()));
//                     // Navigator.push(
//                     //   context,
//                     //   EnterExitRoute(
//                     //     exitPage: widget,
//                     //     enterPage: OtpVerify(
//                     //       number: _cNumber.text,
//                     //     ),
//                     //   ),
//                     // );
//                   } else {
//                     log('Error');
//                   }
//                 },
//                 child: Container(
//                   width: width * 0.5,
//                   padding: EdgeInsets.symmetric(
//                     vertical: 20.0,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                       5.0,
//                     ),
//                     gradient: kGradient,
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Sign In',
//                       style: kSignUpTextStyle,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
