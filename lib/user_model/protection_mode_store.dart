import 'package:shared_preferences/shared_preferences.dart';

/// 보이스피싱 방지 모드의 영구 저장값과 메모리 상태를 함께 관리합니다.
class ProtectionModeStore {
  ProtectionModeStore._();

  static final ProtectionModeStore instance = ProtectionModeStore._();

  static const String _key = 'protection_mode_enabled';

  bool enabled = true;
  bool _isLoaded = false;
  Future<void>? _loading;

  /// SharedPreferences는 실제 앱 실행 중 한 번만 읽습니다.
  Future<void> loadOnce() {
    if (_isLoaded) return Future<void>.value();
    return _loading ??= _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    enabled = preferences.getBool(_key) ?? true;
    _isLoaded = true;
  }

  /// 화면에는 즉시 반영하고, 변경값은 디스크에 저장합니다.
  Future<void> setEnabled(bool value) async {
    enabled = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_key, value);
  }
}
