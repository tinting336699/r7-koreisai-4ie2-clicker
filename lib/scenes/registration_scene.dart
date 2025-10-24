import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../helper/values.dart";
import "../helper/cookie.dart";

import "title_scene.dart";

class RegistrationScene extends StatefulWidget {
  const RegistrationScene({super.key});

  @override
  State<RegistrationScene> createState() => _RegistrationSceneState();
}

class _RegistrationSceneState extends State<RegistrationScene> {
  var name = "";

  @override
  void dispose() {
    context.read<NameHolder>().setName(name);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var name = CookieManager.getName();
    // ユーザー名が保存されている場合はタイトル画面へ
    if (name != null) {
      context.read<NameHolder>().setName(name);
      return const TitleScene();
    }

    // ユーザー名が保存されていない場合は登録画面を表示
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '名前を入力してね',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "※公序良俗に反する名前は使用しないでください",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 12),
                const NameInputForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NameInputForm extends StatefulWidget {
  const NameInputForm({super.key});

  @override
  State<NameInputForm> createState() => _NameInputFormState();
}

class _NameInputFormState extends State<NameInputForm> {
  final TextEditingController _controller = TextEditingController();

  void _goToTitleScene(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TitleScene()),
    );
  }

  Future<void> _registerName(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('名前はあとから変更できません\n先に進みますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
    debugPrint('User confirmed: $confirmed');
    if (confirmed != true) return;
    debugPrint('User confirmdased: $confirmed');
    if (name.trim().isEmpty) return;
    debugPrint('User confirmed:ddasd $confirmed');
    if (!mounted) return;
    context.read<NameHolder>().setName(name.trim());
    CookieManager.saveName(name.trim());
    if (!mounted) return;
    _goToTitleScene(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: '名前',
              border: OutlineInputBorder(),
            ),
            controller: _controller,
            onSubmitted: _registerName,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _registerName(_controller.text),
            child: const Text('登録'),
          ),
        ],
      ),
    );
  }
}
