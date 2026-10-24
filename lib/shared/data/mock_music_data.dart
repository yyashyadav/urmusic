import '../../core/theme/app_colors.dart';
import '../models/track.dart';
import '../models/playlist_model.dart';

class MockMusicData {
  MockMusicData._();

  static const String avatarUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80';

  static const Track trackGoldenHour = Track(
    id: 'track_1',
    title: 'Golden Hour',
    artist: 'JVKE',
    album: 'this is what ____ feels like',
    duration: Duration(minutes: 3, seconds: 40),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&auto=format&fit=crop&q=80',
    isLiked: true,
  );

  static const Track trackDieWithASmile = Track(
    id: 'track_2',
    title: 'Die With A Smile',
    artist: 'Lady Gaga, Bruno Mars',
    album: 'Die With A Smile',
    duration: Duration(minutes: 4, seconds: 11),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&auto=format&fit=crop&q=80',
    isLiked: true,
  );

  static const Track trackApt = Track(
    id: 'track_3',
    title: 'APT.',
    artist: 'ROSÉ, Bruno Mars',
    album: 'rosie',
    duration: Duration(minutes: 2, seconds: 49),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600&auto=format&fit=crop&q=80',
    isLiked: true,
  );

  static const Track trackBirdsOfAFeather = Track(
    id: 'track_4',
    title: 'Birds Of A Feather',
    artist: 'Billie Eilish',
    album: 'HIT ME HARD AND SOFT',
    duration: Duration(minutes: 3, seconds: 5),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=600&auto=format&fit=crop&q=80',
    isLiked: false,
  );

  static const Track trackBeautifulThings = Track(
    id: 'track_5',
    title: 'Beautiful Things',
    artist: 'Benson Boone',
    album: 'Fireworks & Rollerblades',
    duration: Duration(minutes: 3, seconds: 0),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600&auto=format&fit=crop&q=80',
    isLiked: false,
  );

  static const Track trackTheJourney = Track(
    id: 'track_6',
    title: 'The Journey',
    artist: 'Muddy Waters',
    album: 'The Journey EP',
    duration: Duration(minutes: 3, seconds: 42),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&auto=format&fit=crop&q=80',
    isLiked: false,
  );

  static const Track trackLateNight = Track(
    id: 'track_7',
    title: 'Late Night',
    artist: 'Ryan Ellis',
    album: 'Late Night Sessions',
    duration: Duration(minutes: 4, seconds: 21),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=600&auto=format&fit=crop&q=80',
    isLiked: true,
  );

  static List<Track> get allTracks => [
        trackGoldenHour,
        trackDieWithASmile,
        trackApt,
        trackBirdsOfAFeather,
        trackBeautifulThings,
        trackTheJourney,
        trackLateNight,
      ];

  static List<PlaylistModel> get recentlyPlayed => [
        PlaylistModel(
          id: 'playlist_chill_vibes',
          title: 'Chill Vibes',
          subtitle: 'Playlist • 50 songs',
          artworkUrl:
              'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=600&auto=format&fit=crop&q=80',
          songCount: 50,
          tracks: [
            trackGoldenHour,
            trackDieWithASmile,
            trackApt,
            trackBirdsOfAFeather,
            trackBeautifulThings,
          ],
        ),
        PlaylistModel(
          id: 'playlist_liked_songs',
          title: 'Liked Songs',
          subtitle: 'Playlist • 324 songs',
          artworkUrl:
              'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=600&auto=format&fit=crop&q=80',
          songCount: 324,
          tracks: [
            trackGoldenHour,
            trackDieWithASmile,
            trackApt,
            trackLateNight,
          ],
        ),
        PlaylistModel(
          id: 'playlist_the_journey',
          title: 'The Journey',
          subtitle: 'Playlist • 86 songs',
          artworkUrl:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&auto=format&fit=crop&q=80',
          songCount: 86,
          tracks: [trackTheJourney, trackGoldenHour, trackBeautifulThings],
        ),
        PlaylistModel(
          id: 'playlist_late_night',
          title: 'Late Night',
          subtitle: 'Playlist • 72 songs',
          artworkUrl:
              'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=600&auto=format&fit=crop&q=80',
          songCount: 72,
          tracks: [trackLateNight, trackGoldenHour],
        ),
      ];

  static List<PlaylistModel> get madeForYouMixes => [
        PlaylistModel(
          id: 'mix_daily_1',
          title: 'Daily Mix 1',
          subtitle: 'Made for you',
          artworkUrl: '',
          gradient: AppColors.dailyMixGradient,
          songCount: 25,
          tracks: [trackGoldenHour, trackDieWithASmile, trackBirdsOfAFeather],
        ),
        PlaylistModel(
          id: 'mix_chill',
          title: 'Chill Mix',
          subtitle: 'Made for you',
          artworkUrl: '',
          gradient: AppColors.chillMixGradient,
          songCount: 30,
          tracks: [trackGoldenHour, trackTheJourney, trackLateNight],
        ),
        PlaylistModel(
          id: 'mix_focus',
          title: 'Focus Mix',
          subtitle: 'Made for you',
          artworkUrl: '',
          gradient: AppColors.focusMixGradient,
          songCount: 20,
          tracks: [trackTheJourney, trackLateNight],
        ),
      ];

  static List<Track> get trendingNow => [
        trackDieWithASmile,
        trackApt,
        trackBirdsOfAFeather,
        trackBeautifulThings,
      ];
}
