import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import "../helper/firestore.dart";
import "../helper/values.dart";
import "../helper/cookie.dart";
import "title_scene.dart";
import "game_scene.dart";

class ScoreScene extends StatelessWidget {
  const ScoreScene({super.key});

  Future<void> handleScoreUpdate(String name, int score) async {
    final firestoreId = CookieManager.getId();
    if (firestoreId == null) {
      var id = await FirestoreManager.addItem(name, score);
      CookieManager.saveId(id!);
      debugPrint("新規スコア追加");
    } else {
      final fetchedScore = await FirestoreManager.fetchScoreById(firestoreId);
      debugPrint("既存スコア取得: $fetchedScore");
      if (score > (fetchedScore ?? 0)) {
        await FirestoreManager.updateItem(firestoreId, name, score);
        debugPrint("スコア更新");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = context.watch<ScoreHolder>().score;
    final name = context.read<NameHolder>().name;
    handleScoreUpdate(name, score);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'スコア',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '$score',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                ScoreList(),
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Divider(
                    thickness: 2,
                    height: 32,
                    indent: 32,
                    endIndent: 32,
                  ),
                ),
                const MyScore(),
                const SizedBox(height: 16),
                SceneNavigator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreList extends StatefulWidget {
  const ScoreList({super.key});

  @override
  State<ScoreList> createState() => _ScoreListState();
}

class _ScoreListState extends State<ScoreList> {
  late Future<List<Map<String, dynamic>>> _scoreData;

  @override
  void initState() {
    super.initState();
    _scoreData = _getScoreData();
  }

  Future<List<Map<String, dynamic>>> _getScoreData() async {
    final querySnapshot = await FirestoreManager.fetchItems();
    return querySnapshot.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _scoreData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final scores = snapshot.data ?? [];
        final topScores = List.generate(
          5,
          (index) => index < scores.length
              ? scores[index]
              : {"name": "-----", "score": 0},
        );
        return Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      Text("${index + 1}位: "),
                      Text(topScores[index]["name"]),
                      const SizedBox(width: 8),
                      Text("${topScores[index]["score"]}点"),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MyScore extends StatelessWidget {
  const MyScore({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.read<ScoreHolder>().score;
    final name = context.read<NameHolder>().name;
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              '$name  $score点',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class SceneNavigator extends StatelessWidget {
  const SceneNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TitleScene()),
                  );
                },
                child: const Text("タイトルに戻る"),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const GameScene()),
                  );
                },
                child: const Text("リスタート"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
