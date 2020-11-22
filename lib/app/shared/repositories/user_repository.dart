import 'dart:convert';

import 'package:crudcrud/app/shared/auth/auth_controller.dart';
import 'package:crudcrud/app/shared/models/user_model.dart';
import 'package:crudcrud/app/shared/securestorage/storage.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UserRepository {
  AuthController auth = Modular.get();

  Future<List<UserModel>> getUsers() async {
    try {
      print(auth.hash);
      Response response =
          await Dio().get("https://crudcrud.com/api/${auth.hash}/usuarios");
      print(response);

      return UserModel.fromJsonList(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> createUser({UserModel user}) async {
    try {
      print(auth.hash);
      Response response = await Dio().post(
          "https://crudcrud.com/api/${auth.hash}/usuarios",
          data: user.toJsonWithoutId());
      print(response);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      print(auth.hash);
      Response response = await Dio().delete(
        "https://crudcrud.com/api/${auth.hash}/usuarios/$id",
      );
      print(response);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> emailExist(String _email) async {
    bool exist = false;
    return getUsers().then((users) {
      users.forEach((user) {
        if (user.email == _email) {
          exist = true;
        }
      });
    }).then((_) => exist);
  }

  Future<UserModel> loginWithEmail(String _email, String _senha) async {
    String md5senha = md5.convert(utf8.encode(_senha)).toString();
    UserModel _myUser = UserModel();
    return getUsers().then((users) {
      users.forEach((user) {
        if (user.email == _email) {
          if (user.senha == md5senha) {
            //RECUPERAR HASH
            auth.getHash();
            //GRAVAR DADOS NO STORAGE
            auth.whiteStorageUserModel(user);
            //SETAR DADOS NO AUTH
            auth.setarPersistencia(user: user);
            _myUser = user;
          }
        }
      });
    }).then((_) => _myUser);
  }
}
