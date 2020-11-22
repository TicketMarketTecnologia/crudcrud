import 'package:crudcrud/app/shared/models/user_model.dart';
import 'package:crudcrud/app/shared/widgets/renew_hash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oktoast/oktoast.dart';
import 'edit_controller.dart';

class EditPage extends StatelessWidget {
  final UserModel user;
  const EditPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditController controller = Modular.get();
    controller.emailController.text = user.email;
    controller.nomeController.text = user.nome;
    controller.dataController.text = user.aniversario;
    controller.imageController.text = user.imagem;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editando Usuário"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                controller.logout();
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                (user.imagem == null || user.imagem == "")
                    ? CircleAvatar(backgroundColor: Colors.transparent)
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.imagem),
                      ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: controller.emailController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Senha"),
                  controller: controller.senhaController,
                  obscureText: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Repita sua Senha"),
                  obscureText: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Nome"),
                  controller: controller.nomeController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Data Aniversario"),
                  controller: controller.dataController,
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: "Link Foto"),
                    controller: controller.imageController),
                SizedBox(height: 50),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  onPressed: () {},
                  child: Text("Salvar Alterações"),
                )
              ],
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
}
