import 'package:flutter/material.dart';
import 'package:laravelflutter/providers/auth_provider.dart';
import 'package:laravelflutter/screens/onboard_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validePhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              child: Padding(
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
                child: FlatButton(
                  onPressed: () {},
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
}
