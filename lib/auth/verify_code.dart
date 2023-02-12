import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mytest_app/auth/profile.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../model/response-model.dart';
import '../utils.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;
  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  String _vId = "-";

  final TextEditingController _verifyCodeController = TextEditingController();
  // PIN CODE START
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  // PIN CODE END
  bool _isLoading = false;

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    phoneVerfiy(widget.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VERIFICATION',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Enter the code sent to ${widget.phoneNumber}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ],
            ),
            const Divider(
              height: 15,
              color: Colors.transparent,
            ),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "Please type code.";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      selectedFillColor: Colors.grey.shade200,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.blueAccent,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.blue,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: _verifyCodeController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40, // <-- Your width
              height: 50,
              child: FilledButton(
                onPressed: () => verifyCredential(),
                // login(_phoneController.text, "Efficient@soft#1982"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ))),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Loading..',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      )
                    : const Text('Login',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyCredential() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _vId, smsCode: _verifyCodeController.text);

    // Sign the user in (or link) with the credential
    return await auth
        .signInWithCredential(credential)
        // ignore: avoid_print
        .then((value) => {
              // ignore: avoid_print
              print(value),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(phoneNumber: widget.phoneNumber)))
            });
  }

  Future<void> phoneVerfiy(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      toastMessage(
          context, "warning", "Invalid Input!", "Please type phone number");
      return;
    }
    if (phoneNumber.startsWith('09')) {
      phoneNumber = phoneNumber.substring(1, phoneNumber.length);
    }
    try {
      _startLoading();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+95$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          if (kDebugMode) {
            print(verificationId);
          }
          if (kDebugMode) {
            print(resendToken);
          }
          setState(() {
            _isLoading = false;
            _vId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Auth Exception $e.code");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Catch : $e");
      }
    }
  }
}
