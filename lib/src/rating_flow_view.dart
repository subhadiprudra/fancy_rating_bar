import 'dart:io';
import 'dart:ui';
import 'package:fancy_rating_bar/models/response.dart';
import 'package:flutter/material.dart';
import '../../models/rating_theme.dart';
import '../../models/rating_icon.dart';
import '../../models/emoji_rating.dart';
import '../../models/dialog_mode.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingFlowView extends StatefulWidget {
  final RatingTheme theme;
  final RatingIconType ratingIconType;
  final bool useEmojiRating;
  final DialogMode mode;
  final String title;
  final String subtitle;
  final String reviewTitle;
  final String reviewSubtitle;
  final String storeRatingTitle;
  final String storeRatingSubtitle;
  final String thankYouTitle;
  final String thankYouSubtitle;
  final String playStoreUrl;
  final String appStoreUrl;
  final int maxLength;
  final int thankYouDuration; // Duration to show thank you message
  final Function(Response) onSubmit;

  const RatingFlowView({
    super.key,
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
    required this.onSubmit,
  });

  @override
  State<RatingFlowView> createState() => _RatingFlowViewState();
}

class _RatingFlowViewState extends State<RatingFlowView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int rating = 0;
  int hoveredRating = 0;
  String review = '';
  int step = 1; // 1: Rating, 2: Store/Review
  bool isSubmitting = false;
  bool submitted = false;
  bool wentToStore = false; // Track if user went to store
  bool showThankYou = false; // Show thank you when returning from store
  late AnimationController _animationController;
  late AnimationController _progressController;
  final TextEditingController _reviewController = TextEditingController();
  final bool isAndroid = Platform.isAndroid;
  final bool isIOS = Platform.isIOS;
  ResponseType responseType = ResponseType.unknown;

  int get totalSteps => 2;

  @override
  void initState() {
    super.initState();
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _progressController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        // App is paused (user might have gone to store)
        if (wentToStore) {
          debugPrint('App paused - user likely went to store');
        }
        break;
      case AppLifecycleState.resumed:
        responseType = ResponseType.openedStoreToRate;
        // App is resumed (user came back)
        if (wentToStore && !showThankYou) {
          debugPrint('App resumed - user came back from store');
          setState(() {
            showThankYou = true;
          });
          _handleSubmit();
          // Auto-close dialog after showing thank you
          Future.delayed(Duration(seconds: widget.thankYouDuration), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _handleStarClick(int starRating) {
    responseType = ResponseType.rated;
    setState(() {
      rating = starRating;
    });
  }

  void _handleNextStep() {
    if (step == 1 && rating > 0) {
      setState(() {
        step = 2;
      });
      _progressController.animateTo(1.0);
    } else {
      _handleSubmit();
    }
  }

  Future<void> _handleStoreRating(bool isPlayStore) async {
    // Mark that user is going to store
    setState(() {
      wentToStore = true;
    });

    try {
      final url = isPlayStore ? widget.playStoreUrl : widget.appStoreUrl;
      if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        // Don't submit immediately, wait for user to return
      } else {
        // If URL launch fails, reset the flag
        setState(() {
          wentToStore = false;
        });
        _handleSubmit();
      }
    } catch (e) {
      // If error occurs, reset the flag and submit
      setState(() {
        wentToStore = false;
      });
      _handleSubmit();
    }
  }

  void _skipStoreRating() {
    responseType = ResponseType.skippedStoreRating;
    _handleSubmit();
  }

  Future<void> _handleSubmit() async {
    if (!mounted) return;
    setState(() {
      isSubmitting = true;
    });

    try {
      await widget.onSubmit(Response(
        rating: rating,
        type: responseType,
        message: review,
      ));

      if (!mounted) return;
      setState(() {
        submitted = true;
        isSubmitting = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _goBack() {
    setState(() {
      step = 1;
    });
    _progressController.reset();
  }

  Widget _buildRatingIcons() {
    final iconConfig = RatingIcons.configs[widget.ratingIconType]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected =
            starIndex <= (hoveredRating > 0 ? hoveredRating : rating);

        return GestureDetector(
          onTap: () => _handleStarClick(starIndex),
          child: MouseRegion(
            onEnter: (_) => setState(() => hoveredRating = starIndex),
            onExit: (_) => setState(() => hoveredRating = 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.diagonal3Values(
                isSelected ? 1.1 : 1.0,
                isSelected ? 1.1 : 1.0,
                1.0,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                iconConfig.icon,
                size: 40,
                color:
                    isSelected ? iconConfig.color : widget.theme.textMutedColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmojiRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final emojiIndex = index + 1;
        final emoji = EmojiRatings.ratings[emojiIndex]!;
        final isSelected =
            emojiIndex <= (hoveredRating > 0 ? hoveredRating : rating);

        return GestureDetector(
          onTap: () => _handleStarClick(emojiIndex),
          child: MouseRegion(
            onEnter: (_) => setState(() => hoveredRating = emojiIndex),
            onExit: (_) => setState(() => hoveredRating = 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.diagonal3Values(
                isSelected ? 1.25 : 1.0,
                isSelected ? 1.25 : 1.0,
                1.0,
              ),
              child: Text(
                emoji.emoji,
                style: TextStyle(
                  fontSize: 48,
                  color: isSelected ? null : widget.theme.textMutedColor,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProgressBar() {
    if (showThankYou) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $step of $totalSteps',
              style: TextStyle(
                color: widget.theme.textMutedColor,
                fontSize: 12,
              ),
            ),
            Text(
              '${((step / totalSteps) * 100).round()}%',
              style: TextStyle(
                color: widget.theme.textMutedColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: step / totalSteps,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              decoration: BoxDecoration(
                gradient: widget.theme.progressGradient,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRatingStep() {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: widget.theme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitle,
          style: TextStyle(
            color: widget.theme.textSecondaryColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (rating > 0) ...[
          AnimatedOpacity(
            opacity: rating > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                Text(
                  widget.useEmojiRating
                      ? EmojiRatings.ratings[rating]!.emoji
                      : EmojiRatings.ratings[rating]!.emoji,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 8),
                Text(
                  EmojiRatings.ratings[rating]!.label,
                  style: TextStyle(
                    color: widget.theme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        widget.useEmojiRating ? _buildEmojiRating() : _buildRatingIcons(),
        const SizedBox(height: 16),
        Text(
          widget.useEmojiRating
              ? 'Click an emoji to rate'
              : 'Click ${RatingIcons.configs[widget.ratingIconType]!.name.toLowerCase()} to rate',
          style: TextStyle(color: widget.theme.textMutedColor, fontSize: 12),
        ),
        if (rating > 0) ...[
          const SizedBox(height: 32),
          AnimatedOpacity(
            opacity: rating > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.theme.buttonGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.theme.accentColor,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleNextStep,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStoreRatingStep() {
    // Determine which store button to show based on platform

    // Determine the store URL and button details
    String storeUrl = '';
    String storeButtonText = '';
    IconData storeIcon = Icons.star;
    List<Color> storeGradient = [];

    if (isAndroid && widget.playStoreUrl.isNotEmpty) {
      storeUrl = widget.playStoreUrl;
      storeButtonText = 'Rate us on Play Store';
      storeIcon = Icons.android;
      storeGradient = [Color(0xFF01875F), Color(0xFF0F9D58)];
    } else if (isIOS && widget.appStoreUrl.isNotEmpty) {
      storeUrl = widget.appStoreUrl;
      storeButtonText = 'Rate us on App Store';
      storeIcon = Icons.apple;
      storeGradient = [Color(0xFF007AFF), Color(0xFF0056CC)];
    }

    return Column(
      children: [
        Text(
          widget.storeRatingTitle,
          style: TextStyle(
            color: widget.theme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.storeRatingSubtitle,
          style: TextStyle(
            color: widget.theme.textSecondaryColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Large emoji display
        Text(
          '⭐',
          style: const TextStyle(fontSize: 80),
        ),
        const SizedBox(height: 24),
        Text(
          'Your $rating-star rating means a lot to us!',
          style: TextStyle(
            color: widget.theme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Show store button only if URL is available for current platform
        if (storeUrl.isNotEmpty) ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: storeGradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleStoreRating(isAndroid),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(storeIcon, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        storeButtonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Skip button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _skipStoreRating,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: widget.theme.textMutedColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.useEmojiRating
                  ? EmojiRatings.ratings[rating]?.emoji ?? '😊'
                  : EmojiRatings.ratings[rating]?.emoji ?? '😊',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reviewTitle,
                  style: TextStyle(
                    color: widget.theme.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.reviewSubtitle,
                  style: TextStyle(
                    color: widget.theme.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color.fromARGB(51, 255, 255, 255)),
          ),
          child: TextField(
            controller: _reviewController,
            onChanged: (value) {
              setState(() {
                review = value;
              });
            },
            maxLines: 4,
            maxLength: widget.maxLength,
            style: TextStyle(color: widget.theme.textColor),
            cursorColor: widget.theme.textColor,
            decoration: InputDecoration(
              hintText: EmojiRatings.placeholders[rating] ??
                  EmojiRatings.placeholders[3]!,
              hintStyle: TextStyle(color: widget.theme.textMutedColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: TextStyle(color: widget.theme.textMutedColor),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _goBack,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: widget.theme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.theme.buttonGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      responseType = ResponseType.rated;
                      isSubmitting ? null : _handleSubmit();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSubmitting) ...[
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ] else ...[
                            const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThankYouState() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.theme.accentColor.withAlpha(80),
                widget.theme.accentColor,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.thankYouTitle,
          style: TextStyle(
            color: widget.theme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.thankYouSubtitle,
          style: TextStyle(
            color: widget.theme.textSecondaryColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Show user's rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(rating, (index) {
            final iconConfig = RatingIcons.configs[widget.ratingIconType]!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: widget.useEmojiRating
                  ? Text(
                      EmojiRatings.ratings[rating]!.emoji,
                      style: const TextStyle(fontSize: 28),
                    )
                  : Icon(iconConfig.icon, color: iconConfig.color, size: 28),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          'Closing automatically...',
          style: TextStyle(
            color: widget.theme.textMutedColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4ADE80), Color(0xFF10B981)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 24),
        Text(
          'Thank You!',
          style: TextStyle(
            color: widget.theme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your feedback helps us improve our service',
          style: TextStyle(
            color: widget.theme.textSecondaryColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (rating > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(rating, (index) {
              final iconConfig = RatingIcons.configs[widget.ratingIconType]!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: widget.useEmojiRating
                    ? Text(
                        EmojiRatings.ratings[rating]!.emoji,
                        style: const TextStyle(fontSize: 24),
                      )
                    : Icon(iconConfig.icon, color: iconConfig.color, size: 24),
              );
            }),
          ),
      ],
    );
  }

  Widget _getCurrentStep() {
    // Show thank you if user returned from store
    if (showThankYou) {
      return _buildThankYouState();
    }

    if (submitted) {
      return _buildSuccessState();
    }

    if (step == 1) {
      return _buildRatingStep();
    } else {
      // Step 2: Show store rating if > 3, otherwise show review
      if (rating > 3 &&
          ((isAndroid && widget.playStoreUrl.isNotEmpty) ||
              (isIOS && widget.appStoreUrl.isNotEmpty))) {
        return _buildStoreRatingStep();
      } else {
        return _buildReviewStep();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: widget.theme.background.scale(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.theme.accentColor,
              //blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!showThankYou) ...[
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          responseType = ResponseType.closedDialog;
                          _handleSubmit();
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: widget.theme.textMutedColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                  _buildProgressBar(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _getCurrentStep(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
