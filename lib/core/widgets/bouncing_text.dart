import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class BouncingText extends StatefulWidget {
  const BouncingText(
    this.text, {
    super.key,
    required this.style,
    this.interval = const Duration(seconds: 6),
    this.bounceHeight = 6,
    this.highlightColor = Colors.transparent,
  });

  final String text;
  final TextStyle style;
  final Duration interval; // كل قد إيه تتكرر النطة
  final double bounceHeight; // ارتفاع النطة
  final Color highlightColor;

  @override
  State<BouncingText> createState() => _BouncingTextState();
}

class _BouncingTextState extends State<BouncingText>
    with SingleTickerProviderStateMixin {
  static const int _letterMs = 450; // مدة نطة الحرف الواحد
  static const int _staggerMs = 30; // التأخير بين كل حرف والتاني

  late final AnimationController _controller;
  Timer? _timer;

  int get _lettersCount => widget.text.replaceAll(' ', '').length;
  int get _totalMs => _letterMs + _lettersCount * _staggerMs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _totalMs),
    );
    _play();
    _timer = Timer.periodic(widget.interval, (_) => _play());
  }

  @override
  void didUpdateWidget(covariant BouncingText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _controller.duration = Duration(milliseconds: _totalMs);
    }
  }

  void _play() {
    if (mounted) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final elapsed = _controller.value * _totalMs;
        int index = 0;
        final wordWidgets = <Widget>[];

        for (final word in words) {
          final letters = <Widget>[];
          for (final ch in word.characters) {
            final t = ((elapsed - index * _staggerMs) / _letterMs).clamp(
              0.0,
              1.0,
            );
            final wave = math.sin(math.pi * t); // 0 -> 1 -> 0
            final dy = -wave * widget.bounceHeight;
            final color = Color.lerp(
              widget.style.color,
              widget.highlightColor,
              wave,
            );

            letters.add(
              Transform.translate(
                offset: Offset(0, dy),
                child: Text(ch, style: widget.style.copyWith(color: color)),
              ),
            );
            index++;
          }
          wordWidgets.add(
            Row(mainAxisSize: MainAxisSize.min, children: letters),
          );
        }

        return Wrap(spacing: 5, runSpacing: 2, children: wordWidgets);
      },
    );
  }
}
