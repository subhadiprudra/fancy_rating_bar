class EmojiRating {
  final String emoji;
  final String label;

  const EmojiRating({required this.emoji, required this.label});
}

class EmojiRatings {
  static const ratings = {
    1: EmojiRating(emoji: '😠', label: 'Terrible'),
    2: EmojiRating(emoji: '😕', label: 'Poor'),
    3: EmojiRating(emoji: '😐', label: 'Okay'),
    4: EmojiRating(emoji: '😊', label: 'Good'),
    5: EmojiRating(emoji: '🤩', label: 'Amazing'),
  };

  static const placeholders = {
    1: 'We sincerely apologize for your poor experience. Please tell us what went wrong so we can improve and make things right.',
    2: 'We\'re sorry your experience wasn\'t great. What specific issues did you encounter? Your feedback helps us improve.',
    3: 'Thanks for your feedback! What could we have done better to make your experience more enjoyable?',
    4: 'Great to hear you had a good experience! What did you like most? Any suggestions for making it even better?',
    5: 'Wonderful! We\'re thrilled you had an amazing experience. What made it so special? We\'d love to hear the details!',
  };
}
