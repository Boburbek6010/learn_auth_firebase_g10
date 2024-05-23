import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/pages/home_page.dart';

import '../services/auth_service.dart';
import '../services/util_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController surnameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();



  Future<void>register()async{
    String name = nameC.text;
    String surname = surnameC.text;
    String email = emailC.text;
    String pass = passwordC.text;
    String confirmP = confirmPasswordC.text;
    if(name.isEmpty || name.length < 2){
      Utils.fireSnackBar("Name is not filled", context);
    }else if(surname.isEmpty || surname.length < 2){
      Utils.fireSnackBar("Surname is not filled", context);
    }else if(email.isEmpty || email.length < 2 || !email.contains("@")){
      Utils.fireSnackBar("Email is badly formatted", context);
    }else if(pass.isEmpty || pass.length < 5){
      Utils.fireSnackBar("Password should be more than 6 char", context);
    }else if(pass != confirmP){
      Utils.fireSnackBar("Confirm password is not same with password", context);
    }else{
      User? user = await AuthService.registerUser(context, fullName: "$name/$surname", email: email, password: pass);
      if(user != null){
        if(mounted){
          Utils.fireSnackBar("Successfully registered", context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomePage(user: user,)));
        }
      }
    }
    
  }
  
  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
          child: Column(
            children: [
              const Text("Register User", style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(),
                    labelText: "Name"
                  ),
                  controller: nameC,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(),
                      labelText: "Surname"
                  ),
                  controller: surnameC,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(),
                      labelText: "Email"
                  ),
                  controller: emailC,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(),
                      labelText: "Password"
                  ),
                  controller: passwordC,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(),
                      labelText: "Confirm Password"
                  ),
                  controller: confirmPasswordC,
                ),
              ),

              MaterialButton(
                minWidth: double.infinity,
                shape: const StadiumBorder(),
                color: Colors.blueGrey,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 30),

                onPressed: () async => await register(),
                child: const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
