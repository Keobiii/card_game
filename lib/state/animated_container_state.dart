import 'package:flutter/material.dart';

class AnimatedContainerState {
  // properties
  final String image;
  final List<Alignment> positions;
  int currentStep = 0;

  // constructor
  AnimatedContainerState({
    required this.image,
    required this.positions,
  });

  // Getters
  // it will returns the current position of the container
  Alignment get currentAlignment => positions[currentStep];


  // Method
  // this moves the container forward from the list of position
  // if the container move it will return true else false
  bool nextStep() {
    if (currentStep < positions.length - 1) {
      currentStep++;
      return true;
    }
    return false;
  }

  // another Method
  // sends the container to the first position
  void reset() => currentStep = 0;
}
