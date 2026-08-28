class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  int userId = 0;
  String token = '';
  String name = '';
  String profileImage = '';

  void setUserInfo({
    required int userId,
    required String name,
    required String profileImage,
    required String token,
  }) {
    this.userId = userId;
    this.name = name;
    this.profileImage = profileImage;
    this.token = token;
  }

  void clear() {
    userId = 0;
    token = '';
    name = '';
    profileImage = '';
  }
}
