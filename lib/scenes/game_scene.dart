import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'dart:async';

import "score_scene.dart";
import "../helper/values.dart";

class GameScene extends StatefulWidget {
  const GameScene({super.key});

  @override
  State<GameScene> createState() => _GameSceneState();
}

class _GameSceneState extends State<GameScene> {
  int _clicks = 0;
  int _clickPower = 1;
  int _autoClickerCount = 0;
  int _autoClickRate = 0; 
  
  // アップグレードコスト
  int _clickPowerCost = 10;
  int _autoClickerCost = 50;
  
  Timer? _autoClickTimer;

  @override
  void initState() {
    super.initState();
    _startAutoClicker();
  }
  
  @override
  void dispose() {
    _autoClickTimer?.cancel();
    super.dispose();
  }

  void _startAutoClicker() {
    _autoClickTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_autoClickRate > 0) {
        setState(() {
          _clicks += _autoClickRate * _clickPower;
        });
      }
    });
  }

  void _handleClick() {
    setState(() {
      _clicks += _clickPower;
    });
  }

  void _upgradeClickPower() {
    if (_clicks >= _clickPowerCost) {
      setState(() {
        _clicks -= _clickPowerCost;
        _clickPower++;
        _clickPowerCost = (_clickPowerCost * 1.2).round();
      });
    }
  }

  void _buyAutoClicker() {
    if (_clicks >= _autoClickerCost) {
      setState(() {
        _clicks -= _autoClickerCost;
        _autoClickerCount++;
        _autoClickRate += 1; // 1秒あたり1クリック増加 (0.1秒×10回=1秒で1ポイント)
        _autoClickerCost = (_autoClickerCost * 1.5).round();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // スコア表示
              Text(
                'クリック数: $_clicks',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // 1秒あたりの自動クリック数
              Text(
                '自動: $_autoClickRate/秒',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // メインクリックボタン
              GestureDetector(
                onTap: _handleClick,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'クリック!\n+$_clickPower',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // アップグレードボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // クリックパワーアップグレード
                  ElevatedButton(
                    onPressed: _clicks >= _clickPowerCost ? _upgradeClickPower : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Column(
                      children: [
                        const Text('パワーUP'),
                        Text('コスト: $_clickPowerCost'),
                        Text('現在: $_clickPower'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // 自動クリッカー購入
                  ElevatedButton(
                    onPressed: _clicks >= _autoClickerCost ? _buyAutoClicker : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Column(
                      children: [
                        const Text('自動クリック'),
                        Text('コスト: $_autoClickerCost'),
                        Text('所持: $_autoClickerCount'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  context.read<ScoreHolder>().setScore(_clicks);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ScoreScene()),
                  );
                },
                child: const Text('諦める'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
