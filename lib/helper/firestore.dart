import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "constants.dart";
import '../main.dart';

// Firestore操作をまとめたヘルパークラス
class FirestoreManager {
  // データを追加する関数
  static Future<String?> addItem(String name, int score) async {
    try {
      final user = <String, dynamic>{
        "name": name,
        "score": score,
        "createdAt": FieldValue.serverTimestamp(),
      };
      final documentSnapshot = await db.collection(collectionName).add(user);
      debugPrint("ID${documentSnapshot.id}を追加");
      return documentSnapshot.id;
    } catch (error) {
      debugPrint("ユーザー追加に失敗 $error");
      return null;
    }
  }

  // コレクションから全ドキュメントを取得する関数
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  fetchItems() async {
    try {
      final querySnapshot = await db
          .collection(collectionName)
          .orderBy("score", descending: true)
          .get();
      return querySnapshot.docs;
    } catch (error) {
      debugPrint("データ取得に失敗 $error");
      return [];
    }
  }

  // コレクションからドキュメントを削除する関数
  static Future<void> deleteItem(String documentId) async {
    try {
      // "test_game"コレクションの指定したドキュメントIDのデータを削除
      await db.collection(collectionName).doc(documentId).delete();
      debugPrint("id$documentIdを削除");
    } catch (error) {
      debugPrint("削除失敗: $error");
    }
  }

  // コレクションから特定のドキュメントのスコアを取得する関数
  static Future<int?> fetchScoreById(String documentId) async {
    try {
      final documentSnapshot = await db.collection(collectionName).doc(documentId).get();
      final data = documentSnapshot.data();
      return data?['score'] as int?;
    } catch (error) {
      debugPrint("スコア取得失敗: $error");
      return null;
    }
  }

  static Future<void> updateItem(String documentId, String name, int score) async {
    try {
      final user = <String, dynamic>{
        "name": name,
        "score": score,
        "createdAt": FieldValue.serverTimestamp(),
      };
      await db.collection(collectionName).doc(documentId).update(user);
      debugPrint("id$documentIdを更新");
    } catch (error) {
      debugPrint("更新失敗: $error");
    }
  }
}
