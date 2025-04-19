import 'package:flutter/material.dart';

class FlippableCard extends StatefulWidget {
  final String frontImage;
  final Alignment alignment;

  const FlippableCard({
    Key? key,
    required this.frontImage,
    required this.alignment,
  }) : super(key: key);

  @override
  _FlippableCardState createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    if (!_isFront) {
      _controller.forward();
    }

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 500),
        alignment: widget.alignment,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_animation.value * 3.14159),
              alignment: Alignment.center,
              child: _animation.value < 0.5
                  ? _buildBackCard()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                      child: _buildFrontCard(widget.frontImage),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 100,
      height: 150,
      child: Image.asset(
        'assets/images/back.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildFrontCard(String image) {
    return Container(
      width: 100,
      height: 150,
      child: Image.asset(
        image,
        fit: BoxFit.fill,
      ),
    );
  }
}
