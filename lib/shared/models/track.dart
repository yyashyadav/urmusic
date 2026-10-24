import 'package:flutter/material.dart';

class Track {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final Duration duration;
  final String thumbnailUrl;
  final LinearGradient? gradient;
  final bool isLiked;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.duration,
    required this.thumbnailUrl,
    this.gradient,
    this.isLiked = false,
  });

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    Duration? duration,
    String? thumbnailUrl,
    LinearGradient? gradient,
    bool? isLiked,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      gradient: gradient ?? this.gradient,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
