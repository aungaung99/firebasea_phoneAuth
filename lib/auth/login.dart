import 'package:flutter/material.dart';
import 'package:mytest_app/auth/profile.dart';
import 'package:mytest_app/auth/verify_code.dart';

import '../utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

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
                child: const Text('Login',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyCodePage(phoneNumber: phoneNumber)),
    );
  }
}
