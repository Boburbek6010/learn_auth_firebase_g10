import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/pages/register_page.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService.auth.authStateChanges(),
        builder: (context, snapshot) {
          return !snapshot.hasData ? HomePage(user: snapshot.data,):const RegisterPage();
        }
    );
  }
}
