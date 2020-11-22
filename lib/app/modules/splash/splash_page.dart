import 'package:crudcrud/app/shared/auth/auth_controller.dart';
import 'package:crudcrud/app/shared/models/user_model.dart';
import 'package:crudcrud/app/shared/securestorage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ModularState<SplashPage, SplashController> {
  AuthController auth = Modular.get();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1500), () async {
      //RECUPERAR HASH
      auth.getHash();

      //RECUPERAR DADOS DO STORAGE
      UserModel user = await auth.getStorageUserModel();

      if (user.email == null || user.email == "") {
        // NAO POSSUI USUARIO NO STORAGE
        auth.isLogged = false;
        Modular.to.pushReplacementNamed("/login");
      } else {
        // POSSUI USUARIO NO STORAGE
        //SETAR DADOS NO AUTH
        auth.setarPersistencia(user: user);
        Modular.to.pushReplacementNamed("/home");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/logo.png")),
              SizedBox(height: 50),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
