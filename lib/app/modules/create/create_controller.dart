import 'package:crudcrud/app/shared/models/user_model.dart';
import 'package:crudcrud/app/shared/repositories/user_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:convert';
part 'create_controller.g.dart';

@Injectable()
class CreateController = _CreateControllerBase with _$CreateController;

abstract class _CreateControllerBase with Store {
  UserRepository userRepository = Modular.get();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @action
  Future<bool> createUser() async {
    String md5senha = md5.convert(utf8.encode(senhaController.text)).toString();

    return userRepository.createUser(
        user: UserModel(
      nome: nomeController.text,
      aniversario: dataController.text,
      email: emailController.text,
      imagem: imageController.text,
      senha: md5senha,
    ));
  }
}
