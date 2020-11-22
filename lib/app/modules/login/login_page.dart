import 'package:crudcrud/app/shared/auth/auth_controller.dart';
import 'package:crudcrud/app/shared/securestorage/storage.dart';
import 'package:crudcrud/app/shared/widgets/renew_hash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  //use 'controller' variable to access controller
  AuthController auth = Modular.get();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController renewPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/logo.png")),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: emailController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Senha"),
                    controller: senhaController,
                    obscureText: true,
                  ),
                  FlatButton(
                      onPressed: () {
                        renewPassword();
                      },
                      child: Text("Renovar Senha")),
                  SizedBox(height: 50),
                  Observer(builder: (_) {
                    return Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        onPressed: () {
                          controller
                              .loginWithEmail(
                                  emailController.text, senhaController.text)
                              .then((logged) {
                            if (logged) {
                              Modular.to.pushReplacementNamed("/home");
                            } else {
                              showToast("Login e/ou Senha inválidos!",
                                  backgroundColor: Colors.red[600]);
                            }
                          });
                        },
                        child: (controller.isLoading)
                            ? CircularProgressIndicator()
                            : Text("Login"),
                      ),
                    );
                  }),
                  Divider(),
                  RaisedButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed: () {
                        Modular.to.pushNamed("/create");
                      },
                      child: Text(
                        "Criar Novo Usuario",
                        style: TextStyle(color: Colors.black),
                      )),
                  Divider(),
                  (auth.hash == null || auth.hash == "")
                      ? Center(
                          child: Column(
                          children: [
                            Text("Não há Hash cadastrada para o EndPoint!"),
                            Text(
                                "Vamos ao Crud Crud obter uma nova? Clique aqui:"),
                            IconButton(
                                icon: Icon(Icons.cloud_download,
                                    size: 40,
                                    color: Theme.of(context).accentColor),
                                onPressed: () {
                                  _launchURL();
                                })
                          ],
                        ))
                      : Observer(builder: (_) {
                          return Center(child: Text("Hash: ${auth.hash}"));
                        }),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RenewHash();
                });
          },
          label: Text("Hash"),
          icon: Icon(Icons.playlist_add)),
    );
  }

  Future<void> renewPassword() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: 300,
              height: 300,
              child: Card(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: Text("Digite uma nova senha:")),
                        TextFormField(
                          decoration: InputDecoration(labelText: "senha"),
                          controller: renewPassController,
                          obscureText: true,
                        ),
                        Container(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            onPressed: () {
                              //TODO RENOVAR SENHA
                              Modular.to.pop();
                            },
                            child: Text("Salvar"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _launchURL() async {
    const url = 'https://crudcrud.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
