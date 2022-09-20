import '../service/auth_service.dart';
import '../widgets/drawer/drawer_widget.dart';

class DrawerData {
  final String userName;
  final Selected currentPage;
  final Function groupFunction;
  final Function profileFunction;
  final AuthService authServiceInstance;

  DrawerData({
    required this.userName,
    required this.currentPage,
    required this.groupFunction,
    required this.profileFunction,
    required this.authServiceInstance,
  });
}
