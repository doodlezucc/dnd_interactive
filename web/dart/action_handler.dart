import 'dart:html';

import 'package:dnd_interactive/actions.dart';
import 'package:dnd_interactive/point_json.dart';

import '../main.dart';
import 'session/log.dart';
import 'session/prefab_palette.dart';
import 'session/roll_dice.dart';

Future<dynamic> handleAction(String action, Map<String, dynamic> params) async {
  switch (action) {
    case GAME_MOVABLE_CREATE:
      return user.session.board.onMovableCreate(params);

    case GAME_MOVABLE_MOVE:
      return user.session.board.onMovableMove(params);

    case GAME_MOVABLE_UPDATE:
      return user.session.board.onMovableUpdate(params);

    case GAME_MOVABLE_REMOVE:
      return user.session.board.onMovableRemove(params);

    case GAME_SCENE_PLAY:
      int id = params['id'];
      return user.session?.board?.fromJson(id, params);

    case GAME_SCENE_UPDATE:
      var grid = params['grid'];
      if (grid != null) {
        user.session?.board?.grid?.fromJson(grid);
        user.session?.board?.onAllMovablesMove(params['movables']);
      }
      return user.session?.board?.onImgChange();

    case GAME_SCENE_FOG_OF_WAR:
      return user.session?.board?.fogOfWar?.load(params['data']);

    case GAME_JOIN_REQUEST:
      return await user.account?.displayPickCharacterDialog(params['name']);

    case GAME_CONNECTION:
      return user.session?.onConnectionChange(params);

    case GAME_ROLL_DICE:
      return onDiceRoll(params);

    case GAME_PREFAB_CREATE:
      return onPrefabCreate(params);

    case GAME_PREFAB_UPDATE:
      return onPrefabUpdate(params);

    case GAME_PREFAB_REMOVE:
      return onPrefabRemove(getPrefab(params['prefab']));

    case GAME_MAP_CREATE:
      return user.session?.board?.mapTab?.addMap(params['map'], '');

    case GAME_MAP_UPDATE:
      return user.session?.board?.mapTab?.onMapUpdate(params);

    case GAME_MAP_REMOVE:
      return user.session?.board?.mapTab?.onMapRemove(params['map']);

    case GAME_PING:
      var point = parsePoint(params);
      return user.session?.board?.displayPing(point, params['player']);

    case GAME_CHAT:
      return onChat(params);
  }

  window.console.warn('Unhandled action!');
}
