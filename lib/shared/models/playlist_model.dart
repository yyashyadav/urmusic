import 'package:flutter/material.dart';
import 'track.dart';

class PlaylistModel {
  final String id;
  final String title;
  final String subtitle;
  final String artworkUrl;
  final LinearGradient? gradient;
  final int songCount;
  final List<Track> tracks;

  const PlaylistModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.artworkUrl,
    this.gradient,
    required this.songCount,
    this.tracks = const [],
  });
}
