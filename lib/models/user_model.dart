import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number'; //to avoid any typos
  static const ID = 'id';

  late String _number;
  late String _id;

  String get number => _number;
  String get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot[NUMBER];
    _id = snapshot[ID];
  }
}
