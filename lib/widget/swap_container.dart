import 'dart:async';
import 'dart:math';
import 'package:card_game/state/animated_container_state.dart';
import 'package:card_game/utils/animation_algo_list.dart';
import 'package:card_game/widget/flippable_card.dart';
import 'package:flutter/material.dart';

class SwapContainer extends StatefulWidget {
  const SwapContainer({super.key});

  @override
  State<SwapContainer> createState() => _SwapContainerState();
}

class _SwapContainerState extends State<SwapContainer> {
  final List<AnimatedContainerState> containers = [];

  var containerA = Alignment.center;
  var containerB = Alignment.center;
  var containerC = Alignment.center;

  @override
  void initState() {
    super.initState();

    containers.addAll([
      AnimatedContainerState(
        image: 'assets/images/jack_of_spade.png',
        positions: [containerA],
      ),
      AnimatedContainerState(
        image: 'assets/images/queen_of_heart.png',
        positions: [containerB],
      ),
      AnimatedContainerState(
        image: 'assets/images/king_of_spade.png',
        positions: [containerC],
      ),
    ]);
  }

  Timer? _timer; // timer variable
  bool _isAnimating =
      false; // variable to track if the container is in animating or not and set to false (default)

  void _startShuffling() {
    print("Clicked");
    if (_isAnimating) return; // Prevent double clicking

    final algo = algorithms[Random().nextInt(algorithms.length)];

    setState(() {
      containers[0] = AnimatedContainerState(
        image: 'assets/images/jack_of_spade.png',
        positions: algo.aPositions,
      );
      containers[1] = AnimatedContainerState(
        image: 'assets/images/queen_of_heart.png',
        positions: algo.bPositions,
      );
      containers[2] = AnimatedContainerState(
        image: 'assets/images/king_of_spade.png',
        positions: algo.cPositions,
      );

      _isAnimating = true; // mark the animation is running
    });

    //  this starts the loops for every 1 seconds
    // every seconds move container one step forward based on the position list
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      bool anyMoved = false; // use to track if the container is moved or not
      setState(() {
        for (var c in containers) {
          if (c.nextStep()) anyMoved = true;
          // calls the nextStep() functions to move the container position
          // if the return is true then set the "anyMoved" to true else false
        }
      });

      // if the container is not moving anymore
      if (!anyMoved) {
        _timer?.cancel(); // stop the timer
        _isAnimating = false; // allow the user to start again

        // final position of container
        for (var c in containers) {
          print("Container ${c.image} is at ${c.currentAlignment}");

          // set new alignment
          // if (c.label == "A") {
          //   containerA = c.currentAlignment;
          // } else if (c.label == "B") {
          //   containerB = c.currentAlignment;
          // } else if (c.label == "C") {
          //   containerC = c.currentAlignment;
          // }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shuffle Containers")),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Container(
            height: 500,
            width: double.infinity,
            color: Colors.amberAccent,
            child: Stack(
              children:
                  containers
                      .map(
                        (c) => FlippableCard(
                          frontImage: c.image,
                          alignment: c.currentAlignment,
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startShuffling,
        child: const Icon(Icons.shuffle),
      ),
    );
  }

  Widget _buildContainer(String text, Color color) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        // child: Text(
        //   text,
        //   style: const TextStyle(color: Colors.white, fontSize: 20),
        // ),
        child: Image.asset(
          'assets/images/back.png',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
