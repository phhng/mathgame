import 'package:flutter/material.dart';

class ItemBasket {
  ItemBasket({
    required this.uid,
    required this.name,
    required this.imageItem,
    required this.imageFull,
    required this.imageEmpty,
    this.amount = 0,
  });

  final String uid;
  final String name;
  final ImageProvider imageItem;
  final ImageProvider imageFull;
  final ImageProvider imageEmpty;
  int amount;

  bool get hasItems => amount != 0;
}

class PlayerBasket {
  PlayerBasket({
    required this.name,
    required this.imageItem,
    required this.imageFull,
    required this.imageEmpty,
    this.amount = 0,
  });

  final String name;
  final ImageProvider imageItem;
  final ImageProvider imageFull;
  final ImageProvider imageEmpty;
  int amount;

  bool get hasItems => amount != 0;
}