import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

// ブラウザのCookieを直接管理するクラス (Flutter Web専用)
class CookieManager {
  static const String _nameKey = 'username';
  static const String _idKey = 'id';

  // --- ユーザー名 ---

  /// Cookieにユーザー名を保存します。
  /// [maxAge]でCookieの有効期限を秒単位で指定できます (デフォルトは約1年間)。
  static void saveName(String username, {int maxAge = 31536000}) {
    if (kIsWeb) {
      // 日本語などを含む可能性を考慮し、値をエンコードする
      final encodedUsername = Uri.encodeComponent(username);
      html.document.cookie = '$_nameKey=$encodedUsername; path=/; max-age=$maxAge';
    } else {
      print('CookieManager is only supported on the web platform.');
    }
  }

  /// Cookieからユーザー名を取得します。
  static String? getName() {
    if (kIsWeb) {
      final cookies = html.document.cookie?.split(';');
      if (cookies == null) return null;

      for (var cookie in cookies) {
        final parts = cookie.split('=');
        final key = parts[0].trim();

        if (key == _nameKey) {
          final value = parts.sublist(1).join('=');
          // 保存時にエンコードした値をデコードして返す
          return Uri.decodeComponent(value);
        }
      }
    }
    return null;
  }

  /// Cookieからユーザー名を削除します。
  static void clearName() {
    if (kIsWeb) {
      // 有効期限を過去に設定することでCookieを削除する
      html.document.cookie = '$_nameKey=; path=/; max-age=0';
    }
  }

  // --- ID ---

  /// CookieにIDを保存します。
  static void saveId(String id, {int maxAge = 31536000}) {
    if (kIsWeb) {
      final encodedId = Uri.encodeComponent(id);
      html.document.cookie = '$_idKey=$encodedId; path=/; max-age=$maxAge';
    } else {
      print('CookieManager is only supported on the web platform.');
    }
  }

  /// CookieからIDを取得します。
  static String? getId() {
    if (kIsWeb) {
      final cookies = html.document.cookie?.split(';');
      if (cookies == null) return null;
      
      for (var cookie in cookies) {
        final parts = cookie.split('=');
        final key = parts[0].trim();

        if (key == _idKey) {
          final value = parts.sublist(1).join('=');
          return Uri.decodeComponent(value);
        }
      }
    }
    return null;
  }

  /// CookieからIDを削除します。
  static void clearId() {
    if (kIsWeb) {
      html.document.cookie = '$_idKey=; path=/; max-age=0';
    }
  }
}