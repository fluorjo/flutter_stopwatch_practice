import 'package:flutter/material.dart';
import 'dart:async';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  late Timer _timer; // 타이머
  var _time = 0; // 0.01초 마다 1씩 증가시킬 변수
  var _isRunning = false; // 현재 시작

  final List<String> _lapTimes = []; // 랩타임에 표시할 시간을 저장할 리스트

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StopWatch'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(
          () {
            _clickButton();
          },
        ),
        child: _isRunning
            ? const Icon(
                Icons.pause,
              )
            : const Icon(
                Icons.play_arrow,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    var sec = _time ~/ 100;
    var hundredth = '${_time % 100}'.padLeft(2, '0');

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  // 시간 표시 영역
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '$sec', //초
                      style: const TextStyle(
                        fontSize: 50.0,
                      ),
                    ),
                    Text(hundredth), // 1/100초
                  ],
                ),
                SizedBox(
                  //랩타입 표시 영역
                  width: 100,
                  height: 200,
                  child: ListView(
                    children: _lapTimes.map((time) => Text(time)).toList(),
                  ),
                )
              ],
            ),
            Positioned(
              //초기화 버튼
              left: 10,
              bottom: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: _reset,
                child: const Icon(
                  Icons.rotate_left,
                ),
              ),
            ),
            Positioned(
              //랩타임 버튼 버튼
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: () {
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: const Text(
                  '랩타임',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 시작 또는 멈춤 버튼 클릭
  void _clickButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  // 백분의 1초에 한 번씩 time 변수를 1 증가
  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  // 타이머 취소
  void _pause() {
    _timer.cancel();
  }

  // 초기화
  void _reset() {
    setState(() {
      _isRunning = false;
      _timer.cancel();
      _lapTimes.clear();
      _time = 0;
    });
  }

  // 랩타임 기록
  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1}등 $time');
  }
}
