abstract class User {
  late int id;
  late int userRole;

  String getProfileName();
  String getRoleName();

  int getRole() {
    return userRole;
  }
}
