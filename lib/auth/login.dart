import 'package:flutter/material.dart';
import 'package:mytest_app/auth/verify_code.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  // This function will be triggered when the button is pressed
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void setState(VoidCallback fn) async {
    // TODO: implement setState
    super.setState(fn);
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
              children: const [
                Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Continue with phone numbers',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                )
              ],
            ),
            const Divider(
              height: 15,
              color: Colors.transparent,
            ),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: '+95 9 123 123 123',
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  contentPadding: EdgeInsets.all(15)),
            ),
            const Divider(
              height: 15,
              color: Colors.transparent,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40, // <-- Your width
              height: 50,
              child: FilledButton(
                onPressed: () => phoneVerfiy(_phoneController.text),
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
      FirebaseAuth auth = FirebaseAuth.instance;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+95$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          print(verificationId);
          print(resendToken);
          setState(() {
            _isLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyCodePage(
                      verificationId: verificationId,
                      phoneNumber: phoneNumber)),
            );
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto Retrieval: $verificationId');
        },

      );
    } on FirebaseAuthException catch (e) {
      print("Auth Exception $e.code");
    } catch (e) {
      print("Catch : $e");
    }
  }
}
