import 'package:flutter/cupertino.dart';
import 'package:learn_auth_firebase_g10/setup.dart';

import 'app.dart';

Future<void> main()async{
  await setup();
  runApp(const App());
}