import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/response-model.dart';
import '../services/api_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final APIService _apiservice = APIService();
  String fullName = "";
  String role = "";
  String email = "";
  ResponseModel responseModel = ResponseModel();

  @override
  void initState() {
    login("0${widget.phoneNumber}", "Efficient@soft#1982");
    super.initState();
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
            Card(
              margin: const EdgeInsets.all(10),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const Divider(height: 5, color: Colors.transparent),
                      Text(
                        "Email: $email",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(height: 5, color: Colors.transparent),
                      Text(
                        "Role: $role",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> login(String username, String password) async {
    return await _apiservice.token('auth/access-token', body: {
      "username": username,
      "password": password,
    }).then((ResponseModel res) async {
      responseModel = res;
      if (kDebugMode) {
        print(res.toJson());
      }

      if (res.success == true) {
        setState(() {
          fullName = responseModel.data["user"]["fullName"];
          email = responseModel.data["user"]["email"];
          role = responseModel.data["user"]["user_role"];
        });
      }

      final snackBar = SnackBar(
        content: responseModel.success
            ? Text(responseModel.meta["message"])
            : Text(responseModel.error["message"]),
        backgroundColor: Colors.lightGreen,
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
