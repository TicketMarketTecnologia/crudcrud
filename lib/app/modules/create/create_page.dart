import 'package:crudcrud/app/shared/auth/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'create_controller.dart';

class CreatePage extends StatefulWidget {
  final String title;
  const CreatePage({Key key, this.title = "Create"}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends ModularState<CreatePage, CreateController> {
  AuthController auth = Modular.get();
  DateTime selectedDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                InkWell(
                  onTap: () => selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: "Data Aniversario"),
                      controller: controller.dataController,
                    ),
                  ),
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: "Link Foto"),
                    controller: controller.imageController),
                SizedBox(height: 50),
                Container(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    onPressed: () {
                      controller.createUser().then((isCreated) {
                        if (isCreated) {
                          Modular.to.pop();
                          showToast("Usuário Criado com Sucesso!");
                        } else {
                          Modular.to.pop();
                          showToast("Erro ao criar usuário!",
                              backgroundColor: Colors.red[600]);
                        }
                      });
                    },
                    child: Text("Criar Novo"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    double height = MediaQuery.of(context).size.height;
    DateTime today = DateTime.now().toLocal();

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: (height / 2.5),
            child: Column(
              children: [
                Flexible(
                  flex: 5,
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.grey[200],
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: DateTime(today.year - 100),
                    maximumDate: today,
                    initialDateTime: (selectedDate == null)
                        ? DateTime(today.year - 20)
                        : selectedDate,
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        selectedDate = dateTime;
                        controller.dataController.text =
                            DateFormat("dd/MM/yyyy").format(selectedDate);
                      });
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                      onPressed: () {
                        Modular.to.pop();
                      },
                      child: Text("Ok")),
                )
              ],
            ),
          );
        });
  }
}
