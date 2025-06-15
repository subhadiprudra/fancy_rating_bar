import 'package:fancy_rating_bar/models/dialog_mode.dart';
import 'package:fancy_rating_bar/models/rating_icon.dart';
import 'package:fancy_rating_bar/models/rating_theme.dart';

class FancyRatingBarParams {
  int threshold; // After how many calls we should show rating dialog
  int showAgainThreshold; // if someone skipped/closed dialog, how many calls later we should show it again
  bool testMode; // If true, dialog will be shown every time

  RatingTheme theme;
  RatingIconType ratingIconType;
  bool useEmojiRating;
  DialogMode mode;
  String title;
  String subtitle;
  String reviewTitle;
  String reviewSubtitle;
  String storeRatingTitle;
  String storeRatingSubtitle;
  String thankYouTitle;
  String thankYouSubtitle;
  String playStoreUrl;
  String appStoreUrl;
  int maxLength;
  int thankYouDuration; // Duration to show thank you message

  FancyRatingBarParams({
    required this.theme,
    this.ratingIconType = RatingIconType.stars,
    this.useEmojiRating = false,
    this.mode = DialogMode.rating,
    this.title = 'Rate Your Experience',
    this.subtitle = 'How was your overall experience?',
    this.reviewTitle = 'Tell us more!',
    this.reviewSubtitle = 'Share your thoughts (optional)',
    this.storeRatingTitle = 'Show Some Love! ❤️',
    this.storeRatingSubtitle =
        'Help others discover our app by rating us on the store',
    this.thankYouTitle = 'Thank You for Rating Us! 🎉',
    this.thankYouSubtitle =
        'We appreciate you taking the time to rate our app on the store',
    this.playStoreUrl = '',
    this.appStoreUrl = '',
    this.maxLength = 500,
    this.thankYouDuration = 4,
    this.testMode = false,
    this.threshold = 3,
    this.showAgainThreshold = 10,
  });
}
