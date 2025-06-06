import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/rating_theme.dart';
import '../models/rating_icon.dart';
import '../models/emoji_rating.dart';
import '../models/dialog_mode.dart';

class FancyRatingBar extends StatefulWidget {
  final RatingTheme theme;
  final RatingIconType ratingIconType;
  final bool useEmojiRating;
  final DialogMode mode;
  final String title;
  final String subtitle;
  final String reviewTitle;
  final String reviewSubtitle;
  final int maxLength;
  final Function(Map<String, dynamic>) onSubmit;

  const FancyRatingBar({
    super.key,
    required this.theme,
    this.ratingIconType = RatingIconType.stars,
    this.useEmojiRating = false,
    this.mode = DialogMode.rating,
    this.title = 'Rate Your Experience',
    this.subtitle = 'How was your overall experience?',
    this.reviewTitle = 'Tell us more!',
    this.reviewSubtitle = 'Share your thoughts (optional)',
    this.maxLength = 500,
    required this.onSubmit,
  });

  @override
  State<FancyRatingBar> createState() => _FancyRatingBarState();
}

class _FancyRatingBarState extends State<FancyRatingBar>
    with TickerProviderStateMixin {
  int rating = 0;
  int hoveredRating = 0;
  String review = '';
  int step = 1;
  bool isSubmitting = false;
  bool submitted = false;
  late AnimationController _animationController;
  late AnimationController _progressController;
  final TextEditingController _reviewController = TextEditingController();

  bool get showRatingStep =>
      widget.mode == DialogMode.rating || widget.mode == DialogMode.both;
  bool get showReviewStep =>
      widget.mode == DialogMode.review || widget.mode == DialogMode.both;
  int get totalSteps => showRatingStep && showReviewStep ? 2 : 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    if (widget.mode == DialogMode.review) {
      step = 1;
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _handleStarClick(int starRating) {
    setState(() {
      rating = starRating;
    });
  }

  void _handleNextStep() {
    if (widget.mode == DialogMode.rating) {
      _handleSubmit();
    } else if (showReviewStep && step == 1 && showRatingStep) {
      setState(() {
        step = 2;
      });
      _progressController.animateTo(1.0);
    } else {
      _handleSubmit();
    }
  }

  Future<void> _handleSubmit() async {
    if (!mounted) return;
    setState(() {
      isSubmitting = true;
    });

    try {
      await widget.onSubmit({'rating': rating, 'review': review});

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

  void _resetDialog() {
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
    if (totalSteps <= 1) return const SizedBox.shrink();

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
            child: Column(
              children: [
                Container(
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
                              widget.mode == DialogMode.rating
                                  ? 'Submit'
                                  : showReviewStep
                                      ? 'Next'
                                      : 'Submit',
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
                if (showReviewStep && widget.mode == DialogMode.both) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Continue to write a review (optional)',
                    style: TextStyle(
                      color: widget.theme.textMutedColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.mode == DialogMode.both) ...[
              Text(
                widget.useEmojiRating
                    ? EmojiRatings.ratings[rating]?.emoji ?? '😊'
                    : EmojiRatings.ratings[rating]?.emoji ?? '😊',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
            ],
            Column(
              crossAxisAlignment: widget.mode == DialogMode.review
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mode == DialogMode.review
                      ? widget.title
                      : widget.reviewTitle,
                  style: TextStyle(
                    color: widget.theme.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.mode == DialogMode.review
                      ? widget.subtitle
                      : widget.reviewSubtitle,
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
              hintText: widget.mode == DialogMode.review
                  ? 'Share your thoughts and feedback...'
                  : EmojiRatings.placeholders[rating] ??
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
            if (widget.mode == DialogMode.both) ...[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _resetDialog,
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
            ],
            Expanded(
              flex: widget.mode == DialogMode.both ? 1 : 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.theme.buttonGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isSubmitting ? null : _handleSubmit,
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: widget.theme.background.scale(0.9),
          borderRadius: BorderRadius.circular(24),
          // border: Border.all(color: const Color.fromARGB(51, 255, 255, 255)),
          boxShadow: [
            BoxShadow(
              color: widget.theme.accentColor,
              blurRadius: 10,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: widget.theme.textMutedColor,
                        size: 24,
                      ),
                    ),
                  ),
                  _buildProgressBar(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: submitted
                        ? _buildSuccessState()
                        : (step == 1 && showRatingStep)
                            ? _buildRatingStep()
                            : _buildReviewStep(),
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
