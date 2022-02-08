import 'package:flutter/material.dart';



class PhoneAuthWidgets {
  static Widget getLogo({String? logoPath, double? height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: Image.asset(logoPath!, height: height),
      );
}

class SearchCountryTF extends StatelessWidget {
  final TextEditingController controller;

  const SearchCountryTF({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
      child: Card(
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Rechercher votre pays',
            contentPadding:  EdgeInsets.only(
                left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? prefix;

  const PhoneNumberField({Key? key, required this.controller, this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Text("  " + prefix! + "  ", style: const TextStyle(fontSize: 16.0)),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              autofocus: false,
              keyboardType: TextInputType.phone,
              key: const Key('EnterPhone-TextFormField'),

              validator: (value) {
                if (value!.isEmpty) {
                  return "Le numéro de téléphone est obligatoire";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String? text;

  const SubTitle({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(' $text',
            style: const TextStyle(color: Colors.white, fontSize: 14.0)));
  }
}


