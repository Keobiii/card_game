import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({super.key});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  // "SingleTickerProviderStateMixin" provides way to create single animation controller

  // declare controller and animation
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    // Initializing the animation controller
    _controller = AnimationController(
      // duration of card to flip
      duration: const Duration(microseconds: 600),
      // synchronize the animation with flutter framework
      vsync: this,
    );

    // Initialize animation
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // "begin: 0, end: 1" progress indicator for flip
    // 0 means card fully visible
    // 1 means represent the back card

    // second animation
    
  }

  // function that responsible for handling flipping action
  // checking the state of the card and provide the animation
  void _toggleCard() {
    if (_isFront) {
      // transitioning the card from 0 - 1
      _controller.forward();
    } else {
      // transitioning the card from 1 - 0
      _controller.reverse();
    }

    // update the state to rebuild the widget and update UI accordingly
    setState(() {
      _isFront = !_isFront;
    });
  }

  // disposing the controller to avoid memory leaks when app is not using
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flip Card Animation')),
      body: Center(
        child: GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            // "AnimatedBuilder" allow to rebuild parts of UI based on the changes in animation
            animation: _animation,
            builder: (context, child) {
              return Transform(
                // "Transform" allows to apply transformation to its child based on provided matrix
                transform: Matrix4.rotationY(_animation.value * 3.14159),
                // rotate child along with Y-axis
                alignment: Alignment.center,
                // card display based the animation value
                child:
                    _animation.value < 0.5
                        ? _builFronCard()
                        : Transform.scale(
                          scaleX: -1,
                          scaleY: 1,
                          child: _buildBackCard(),
                        ),
                
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _builFronCard() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Front',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }


  Widget _buildBackCard() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Back',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
