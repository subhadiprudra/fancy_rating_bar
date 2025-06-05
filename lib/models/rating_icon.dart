import 'package:flutter/material.dart';

// Rating Icon Types
enum RatingIconType {
  stars,
  hearts,
  thumbs,
  lightning,
  coffee,
  music,
  smile,
  award,
  gift,
}

// Rating Icon Configuration
class RatingIconConfig {
  final String name;
  final IconData icon;
  final Color color;

  const RatingIconConfig({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class RatingIcons {
  static const configs = {
    RatingIconType.stars: RatingIconConfig(
      name: 'Stars',
      icon: Icons.star,
      color: Color(0xFFFBBF24),
    ),
    RatingIconType.hearts: RatingIconConfig(
      name: 'Hearts',
      icon: Icons.favorite,
      color: Color(0xFFF87171),
    ),
    RatingIconType.thumbs: RatingIconConfig(
      name: 'Thumbs',
      icon: Icons.thumb_up,
      color: Color(0xFF60A5FA),
    ),
    RatingIconType.lightning: RatingIconConfig(
      name: 'Lightning',
      icon: Icons.flash_on,
      color: Color(0xFFA855F7),
    ),
    RatingIconType.coffee: RatingIconConfig(
      name: 'Coffee',
      icon: Icons.local_cafe,
      color: Color(0xFFF59E0B),
    ),
    RatingIconType.music: RatingIconConfig(
      name: 'Music',
      icon: Icons.music_note,
      color: Color(0xFFF472B6),
    ),
    RatingIconType.smile: RatingIconConfig(
      name: 'Smile',
      icon: Icons.sentiment_satisfied,
      color: Color(0xFF4ADE80),
    ),
    RatingIconType.award: RatingIconConfig(
      name: 'Award',
      icon: Icons.emoji_events,
      color: Color(0xFFFB923C),
    ),
    RatingIconType.gift: RatingIconConfig(
      name: 'Gift',
      icon: Icons.card_giftcard,
      color: Color(0xFF818CF8),
    ),
  };
}
