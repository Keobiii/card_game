import 'package:card_game/utils/animation_algo_model.dart';
import 'package:flutter/material.dart';

final List<AnimationAlgorithm> algorithms = [
  // Existing one
  AnimationAlgorithm(
    [ 
      Alignment.center,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.center,
      Alignment.center,
      Alignment.centerRight
    ],
    [
      Alignment.center,
      Alignment.center,
      Alignment.center,
      Alignment.centerRight,
      Alignment.topCenter,
      Alignment.centerLeft
    ],
    [
      Alignment.center,
      Alignment.centerRight,
      Alignment.center,
      Alignment.centerLeft,
      Alignment.bottomCenter,
      Alignment.center
    ]
  ),

  AnimationAlgorithm(
    [
      Alignment.center,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.center,
      Alignment.center,
      Alignment.centerRight,

    ], 
    [
      Alignment.center,
      Alignment.center,
      Alignment.centerLeft,
      Alignment.topCenter,
      Alignment.centerRight,
      Alignment.center,

    ], 
    [
      Alignment.center,
      Alignment.centerRight,
      Alignment.centerRight,
      Alignment.bottomCenter,
      Alignment.centerLeft,
      Alignment.centerLeft,
    ],
  ),

  AnimationAlgorithm(
    [
      Alignment.center,
      Alignment.centerRight,
      Alignment.center,
      Alignment.center,
      Alignment.center,
      Alignment.centerLeft,

    ], 
    [
      Alignment.center,
      Alignment.centerLeft,
      Alignment.centerLeft,
      Alignment.bottomCenter,
      Alignment.centerRight,
      Alignment.centerRight,

    ], 
    [
      Alignment.center,
      Alignment.center,
      Alignment.centerRight,
      Alignment.topCenter,
      Alignment.centerLeft,
      Alignment.center,
    ],
  )
  


];
