import 'package:dnd_interactive/actions.dart';

import 'account.dart';
import 'communication.dart';
import 'home.dart' as home;
import 'section_page.dart';
import 'session/session.dart';

class User {
  MyAccount _account;
  MyAccount get account => _account;

  bool get registered => account != null;

  Session _session;
  Session get session => _session;

  Future<StateError> joinSession(String id, [String name]) async {
    var s = await socket.request(GAME_JOIN, {
      'id': id,
      if (name != null) 'name': name,
    });
    if (s is String) return StateError(s);

    _session = Session(id, s['name'], s['dm'] != null);
    _session.fromJson(s);
    showPage('session');
    return null;
  }

  void joinFromJson(Map<String, dynamic> s, bool instantEdit) {
    _session = Session(s['id'], s['name'], s['dm'] != null);
    _session.fromJson(s, instantEdit: instantEdit);
    showPage('session');
  }

  void onActivate([Map<String, dynamic> accJson]) {
    _account = MyAccount(accJson);
    home.onLogin();
  }

  Future<bool> login(String email, String password) async {
    var response = await socket.request(
      ACCOUNT_LOGIN,
      {
        'email': email,
        'password': password,
      },
    );
    if (response != false) {
      onActivate(response);
      return true;
    }
    return false;
  }

  Future<bool> loginToken(String token) async {
    var response = await socket.request(ACCOUNT_LOGIN, {'token': token});
    if (response != false) {
      onActivate(response);
      return true;
    }
    return false;
  }
}
