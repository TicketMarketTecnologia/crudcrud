import 'package:crudcrud/app/shared/auth/auth_controller.dart';
import 'package:crudcrud/app/shared/models/user_model.dart';
import 'package:crudcrud/app/shared/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  UserRepository userRepository = Modular.get();
  AuthController auth = Modular.get();
  _HomeControllerBase(this.userRepository) {
    getUsers();
  }

  @observable
  bool isLoading = false;

  @observable
  ObservableList<UserModel> users;

  @action
  Future<void> getUsers() async {
    isLoading = true;
    users = (await userRepository.getUsers()).asObservable();
    isLoading = false;
  }

  @action
  Future<bool> deleteUser(String id) async {
    isLoading = true;
    return userRepository.deleteUser(id).then((success) async {
      if (success) {
        await getUsers();
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    });
  }

  @action
  Future<void> logout() async {
    auth.logout();
  }
}
