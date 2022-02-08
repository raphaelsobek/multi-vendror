import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laravelflutter/screens/home_screen.dart';
import 'package:laravelflutter/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  late String error = '';
  final UserServices _userServices = UserServices();

  Future<void> verifyPhone(BuildContext context, String number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print(e.code);
    };

    final PhoneCodeSent smsOptsend = (String verId, int? resendToken) async {
      this.verificationId = verId;
      smsOptDialog(context, number);
    } as PhoneCodeSent;

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verId) {
      this.verificationId = verId;
    };

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOptsend,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e);
    }
  }

  Future<void> smsOptDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: const [
                Text('Verification'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OPT received as sms',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsOtp);
                    final User user = (await _auth
                        .signInWithCredential(phoneAuthCredential)) as User;
                    // create users data in  firestore after user registration succesfully
                    _createUser(id: user.uid, number: user.phoneNumber);
                    // navigate to home pages after login
                    if (user != null) {
                      Navigator.of(context).pop();
                      // dont want to come back to welcome screen after logged in
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    } else {
                      print('Login Failed');
                    }
                  } catch (e) {
                    error = 'invalid OTP';
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('DONE'),
              ),
            ],
          );
        });
  }

  void _createUser({String? id, String? number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
    });
  }
}
