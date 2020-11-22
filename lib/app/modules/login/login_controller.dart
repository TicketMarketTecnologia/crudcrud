import 'package:crudcrud/app/shared/auth/auth_controller.dart';
import 'package:crudcrud/app/shared/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  UserRepository userRepository = Modular.get();
  AuthController auth = Modular.get();

  @observable
  bool isLoading = false;

  Future<bool> emailExist(String _email) {
    return userRepository.emailExist(_email);
  }

  Future<bool> loginWithEmail(String _email, String _senha) {
    isLoading = true;
    return userRepository.loginWithEmail(_email, _senha).then((user) {
      if (user.id == null) {
        auth.isLogged = false;
        isLoading = false;
        return false;
      } else {
        auth.isLogged = true;
        isLoading = false;
        return true;
      }
    });
  }
}
