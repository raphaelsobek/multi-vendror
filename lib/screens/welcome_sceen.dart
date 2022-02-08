import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laravelflutter/providers/auth/firebase/auth/phone_auth/verify.dart';
import 'package:laravelflutter/providers/auth/providers/phone_auth.dart';
import 'package:laravelflutter/providers/auth_provider.dart';
import 'package:laravelflutter/screens/onboard_screen.dart';
import 'package:provider/provider.dart';


class WelcomeScreen extends StatefulWidget {


   const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenSate createState() => WelcomeScreenSate();
}


class WelcomeScreenSate extends State<WelcomeScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>(
      debugLabel: "scaffold-get-phone");

      
  startPhoneAuth() async {
    final phoneAuthDataProvider =
    Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;

    bool validPhone = await  phoneAuthDataProvider.instantiate(
        dialCode: '+243',
        onCodeSent: () {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (BuildContext context) => PhoneAuthVerify()));
        },
        onFailed: () {
          _showSnackBar(phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Le numéro du téléphone est invalide");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validePhoneNumber = false;
    var _phoneNumberController = TextEditingController();
  final loader = Provider
        .of<PhoneAuthDataProvider>(context)
        .loading;
    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(color: Colors.redAccent, fontSize: 25.0),
                  ),
                  const Text(
                    'Enter your Phone number to proceed',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        prefixText: '+243',
                        labelText: '10 digit mobile number'),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    onChanged: (String value) {
                      if (value.length == 11) {
                        myState(() {
                          _validePhoneNumber = true;
                        });
                      } else {
                        myState(() {
                          _validePhoneNumber = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: _validePhoneNumber ? false : true,
                          child: FlatButton(
                            child: Text(
                              _validePhoneNumber
                                  ? 'CONTINUE'
                                  : 'Enter phone Number',
                              style: const TextStyle(color: Colors.white),
                            ),
                            color: _validePhoneNumber
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            onPressed: () {
                              String number =
                                  '+243${_phoneNumberController.text}';
                              auth.verifyPhone(context, number);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 10.0,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'SKIP',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
              Column(
                children: [
                  const Expanded(
                    child: OnboardScreen(),
                  ),
                  const Text(
                    'Ready to order your services ?',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    color: Colors.redAccent,
                    child: const Text(
                      'Set your Delivery Locations',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already a customer?',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent))
                        ],
                      ),
                    ),
                    onPressed: () {
                      showBottomSheet(context);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
