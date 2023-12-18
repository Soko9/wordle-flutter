import "package:flutter/material.dart";

class DanceAnimation extends StatefulWidget {
  final Widget child;
  final bool animate;
  final int delay;

  const DanceAnimation({
    super.key,
    required this.child,
    required this.animate,
    required this.delay,
  });

  @override
  State<DanceAnimation> createState() => _DanceAnimationState();
}

class _DanceAnimationState extends State<DanceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _animation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(0, -0.8)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(0, -0.8), end: const Offset(0, 0)),
        weight: 12,
      ),
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0.2)),
        weight: 9,
      ),
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, 0.2), end: const Offset(0, 0)),
        weight: 6,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DanceAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () async {
        if (mounted) {
          await _controller.forward();
          await _controller.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
