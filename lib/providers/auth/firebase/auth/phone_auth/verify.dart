import 'package:laravelflutter/providers/auth/providers/phone_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneAuthVerify extends StatefulWidget {

  final String appName = "Entrez le code de validation";

  PhoneAuthVerify({Key? key}) : super(key: key);

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double? _height, _width;
  bool isLoading = false;
  String code = "";

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey =
  GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    final phoneAuthDataProvider =
    Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _getBody() => Container(
        color: Colors.blueGrey,
        child: SizedBox(
          height: _height! * 8 / 10,
          width: _width! * 8 / 10,
          child: _getColumnBody(),
        ),
      );

  Widget _getColumnBody() => Column(
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Text(widget.appName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),

          const SizedBox(height: 20.0),

          //  Info text
          Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: "S'il vous plait entrer le ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: 'Code à usage unique',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                        text: ' envoyé sur votre mobile',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
            ],
          ),

          const SizedBox(height: 16.0),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              const SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              const SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              const SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              const SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              const SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              const SizedBox(width: 5.0),
            ],
          ),

          const SizedBox(height: 32.0),

          RaisedButton(
            elevation: 16.0,
            onPressed: signIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading == true ? const CircularProgressIndicator() : const Text(
                'VERIFIER',
                style: TextStyle(
                    color: Colors.blue, fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          )
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  signIn() {
    setState(() {
      isLoading = true;
    });
    if (code.length != 6) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Code invalide");
    }

    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
    setState(() {
      isLoading = false;
    });
  }


  Widget getPinField({String? key, FocusNode? focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key!),
          expands: false,
          autofocus: false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );

  onStarted() {

    _showSnackBar("Authentification demarrée");
  }

  onCodeSent() {
    _showSnackBar("Code envoyé");
  }

  onCodeResent() {
    _showSnackBar("Code renvoyé");
  }

  onVerified() async {
    _showSnackBar(
        "${Provider
            .of<PhoneAuthDataProvider>(context, listen: false)
            .message}");
    await Future.delayed(const Duration(seconds: 1));
  }

  onFailed() {
    _showSnackBar("Authetification échouée");
  }

  onError() {
    _showSnackBar(
        "Cette erreur s'est : ${Provider
            .of<PhoneAuthDataProvider>(context, listen: false)
            .message}  vient de se produire");
  }

  onAutoRetrievalTimeOut() {
    _showSnackBar("Délai d'expiration de la récupération automatique de vérification.");
  }
}
