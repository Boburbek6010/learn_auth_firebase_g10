import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/pages/register_page.dart';
import 'package:learn_auth_firebase_g10/pages/rt_page.dart';
import 'package:learn_auth_firebase_g10/pages/storage_page.dart';

import '../services/auth_service.dart';
import 'fs_page.dart';
import 'home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService.auth.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData ? const StoragePage():const RegisterPage();
        }
    );
  }
}
