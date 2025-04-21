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

class _SwapContainerState extends State<SwapContainer>
    with SingleTickerProviderStateMixin {
  // Flip Card Animations
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  // Cards
  final List<AnimatedContainerState> containers = [];

  var containerA = Alignment.centerLeft;
  var containerB = Alignment.center;
  var containerC = Alignment.centerRight;

  var userSelected = "";
  var result = "";

  @override
  void initState() {
    super.initState();

    // Flip Card Animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    if (!_isFront) {
      _controller.forward();
    }

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // add item on the list
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

  // Flip Card function
  void _toggleCard() {
    if (!_isFront) {
      _controller.forward();
    }
    // else {
    //   _controller.reverse();
    // }

    // if (!_isFront) {
    //   _controller.reverse();
    // }

    setState(() {
      _isFront = !_isFront;
    });
  }

  Timer? _timer; // timer variable
  bool _isAnimating =
      false; // variable to track if the container is in animating or not and set to false (default)

  void _startShuffling() {
    print("Clicked");
    if (_isAnimating) return; // Prevent double clicking

    timeLeft = 5;
    userSelected = "";

    if (_isFront) {
      _controller.reverse();
      print('Card is at Back');
    }

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
      _isFront = !_isFront;
    });

    //  this starts the loops for every 1 seconds
    // every seconds move container one step forward based on the position list
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
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

        // start countdown
        _starCountDown();

        // final position of container
        for (var c in containers) {
          // print("Container ${c.image} is at ${c.currentAlignment}");

          if (c.image == 'assets/images/queen_of_heart.png') {
            print("Queen at ${c.currentAlignment}");
            result = c.currentAlignment.toString();
          }
          // set new alignment
          // if (c.label == "A") {
          //   containerA = c.currentAlignment;
          // } else if (c.label == "B") {
          //   containerB = c.currentAlignment;
          // } else if (c.label == "C") {
          //   containerC = c.currentAlignment;
          // }
          if (c.image == 'assets/images/jack_of_spade.png') {
            containerA = c.currentAlignment;
          } else if (c.image == 'assets/images/queen_of_heart.png') {
            containerB = c.currentAlignment;
          } else if (c.image == 'assets/images/king_of_spade.png') {
            containerC = c.currentAlignment;
          }
        }
      }
    });
  }

  // time variable
  int timeLeft = 5;
  void _starCountDown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        print('Done');
        _toggleCard();
        if (userSelected != null || userSelected.isNotEmpty) {
          print('User Selected: $userSelected');
          print('Result: $result');
        }

        if (userSelected == '1' && result == 'Alignment.centerLeft') {
          print('you choose 1 and You guess it correct!');
        } else if (userSelected == '2' && result == 'Alignment.center') {
          print('you choose 2 and You guess it correct! ');
        } else if (userSelected == '3' && result == 'Alignment.centerRight') {
          print('you choose 3 and You guess it correct!');
        } else {
          print('You guess it wrong');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shuffle Containers")),
      body: Container(
        height: double.infinity,
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CountDown: $timeLeft', style: TextStyle(fontSize: 25)),
              SizedBox(height: 50),
              Container(
                height: 370,
                width: double.infinity,
                color: Colors.amberAccent,
                child: Stack(
                  children:
                      containers
                          .map(
                            (c) => _FlippableCard(c.image, c.currentAlignment),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      userSelected = '1';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text('Bet', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userSelected = '2';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                    ),
                    child: Text('Bet', style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userSelected = '3';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                    ),
                    child: Text('Bet', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startShuffling,
        child: const Icon(Icons.shuffle),
      ),
    );
  }

  Widget _FlippableCard(String image, Alignment alignment) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 400),
        alignment: alignment,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_animation.value * 3.14159),
              alignment: Alignment.center,
              child:
                  _animation.value < 0.5
                      ? _buildBackCard()
                      : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                        child: _buildFrontCard(image),
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 80,
      height: 110,
      child: Image.asset('assets/images/back.png', fit: BoxFit.fill),
    );
  }

  Widget _buildFrontCard(String image) {
    return Container(
      width: 80,
      height: 110,
      child: Image.asset(image, fit: BoxFit.fill),
    );
  }
}
