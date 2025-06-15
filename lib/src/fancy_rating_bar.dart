import 'package:fancy_rating_bar/models/response.dart';
import 'package:fancy_rating_bar/src/fancy_rating_bar_params.dart';
import 'package:fancy_rating_bar/src/rating_flow_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FancyRatingBar {
  BuildContext context;
  static FancyRatingBar? _instance;
  SharedPreferences? _prefs;

  FancyRatingBar._({
    required this.context,
  });

  static FancyRatingBar of(BuildContext context) {
    _instance ??= FancyRatingBar._(context: context);
    return _instance!;
  }

  void handleAutomaticRating({
    required FancyRatingBarParams params,
    Function(Response response)? onSubmit,
  }) async {
    if (params.testMode) {
      // If test mode is enabled, show dialog immediately
      showRatingDialog(params, (Response response) async {
        onSubmit?.call(response);
      });
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    //_prefs?.clear();
    int callCount = _prefs?.getInt('call_count') ?? 0;
    bool shown = _prefs?.getBool('dialog_shown') ?? false;
    bool openedStoreToRate = _prefs?.getBool('opened_store_to_rate') ?? false;

    // Increment call count
    callCount++;
    _prefs?.setInt('call_count', callCount);

    if (openedStoreToRate || callCount < params.threshold) {
      return;
    }

    if (shown) {
      int c = (callCount - params.threshold) % params.showAgainThreshold;
      if (c != 0) {
        return; // Don't show dialog if not time to show again
      }
    } else {
      if (callCount != params.threshold) {
        return;
      }
    }

    // Show the rating dialog
    showRatingDialog(params, (Response response) async {
      if (response.type == ResponseType.openedStoreToRate) {
        _prefs?.setBool('opened_store_to_rate', true);
      }
      _prefs?.setBool('dialog_shown', true);
      onSubmit?.call(response);
    });
  }

  showRatingDialog(FancyRatingBarParams params, Function(Response) onSubmit) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => RatingFlowView(
        theme: params.theme,
        ratingIconType: params.ratingIconType,
        useEmojiRating: params.useEmojiRating,
        mode: params.mode,
        playStoreUrl: params.playStoreUrl,
        appStoreUrl: params.appStoreUrl,
        title: params.title,
        subtitle: params.subtitle,
        reviewTitle: params.reviewTitle,
        reviewSubtitle: params.reviewSubtitle,
        storeRatingTitle: params.storeRatingTitle,
        storeRatingSubtitle: params.storeRatingSubtitle,
        thankYouTitle: params.thankYouTitle,
        thankYouSubtitle: params.thankYouSubtitle,
        maxLength: params.maxLength,
        thankYouDuration: params.thankYouDuration,
        onSubmit: (Response response) async {
          debugPrint('Rating dialog response: ${response.toJson()}');
          onSubmit.call(response);
        },
      ),
    );
  }
}
