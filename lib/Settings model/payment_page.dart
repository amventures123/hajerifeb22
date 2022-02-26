import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hajeri/main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay extends StatefulWidget {
  const RazorPay({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RazorPay> {
  final TextEditingController qrcode = TextEditingController()
    ..text = prefs.getString("count");
  final TextEditingController gstnum = TextEditingController();

  Razorpay _razorpay;
  bool toggle = false;
  String count;

  int totalAmt, sgst, cgst, igst;
  double amountToPay = 0;

  @override
  void initState() {
    super.initState();
    initializeRazorPay();

    setState(() {
      count = prefs.getString("count");
    });
    log("GEt COunt" + count);
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void displayTotal() {
    setState(() {
      int amount = 300;
      double gstAmount = (amount / 100) * 18;

      double totalAmount = amount + gstAmount;

      log("totalAmount:  " + totalAmount.toString());
      log("GST Amount: " + gstAmount.toString());

      amountToPay = int.parse(qrcode.text) * totalAmount;
      toggle = true;
    });
  }

  void launchRazorPay() {
    log("entered");
    int amount = 300;
    double gstAmount = (amount / 100) * 18;

    double totalAmount = amount + gstAmount;
    totalAmount = totalAmount * 100;

    log("totalAmount:  " + totalAmount.toString());
    log("GST Amount: " + gstAmount.toString());

    double amountToPay2 = int.parse(qrcode.text) * totalAmount;

    var options = {
      'key': 'rzp_live_zFWaOQzThKUPm4',
      'amount': "$amountToPay2",
      'name': qrcode.text,
      'description': gstnum.text,
      // 'prefill': {'contact': phoneNo.text, 'email': email.text}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");

    print(
        "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payemt Failed");

    print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text("Payment Page"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              textField(size, "No. of QR Code", true, qrcode, false),
              // textField(size, "Phone no.", false, phoneNo),
              // textField(size, "Email", false, email),
              textField(size, "GST Number (Optional)", false, gstnum, true),
              Column(children: [
                Column(
                  children: [
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[800]),
                          onPressed:
                              qrcode.text.isNotEmpty ? displayTotal : null,
                          child: const Text("Calculate Bill Amount with GST")),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "₹ " + amountToPay.toString(),
                      style: const TextStyle(fontSize: 50),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                Visibility(
                  visible: toggle,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue[800]),
                    onPressed: () {
                      launchRazorPay();
                    },
                    child: const Text(
                      "Pay Now",
                      // style: kAppBarTextstyle,
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget textField(Size size, String text, bool isNumerical,
      TextEditingController controller, bool b) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 50),
      child: Container(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          enableInteractiveSelection: b,
          focusNode: AlwaysDisabledFocusNode(),
          controller: controller,
          keyboardType: isNumerical ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: text,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
