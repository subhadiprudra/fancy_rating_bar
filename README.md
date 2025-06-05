# Fancy Rating Dialog

[![pub package](https://img.shields.io/pub/v/fancy_rating_dialog.svg)](https://pub.dev/packages/fancy_rating_dialog)
[![likes](https://img.shields.io/pub/likes/fancy_rating_dialog)](https://pub.dev/packages/fancy_rating_dialog/score)
[![popularity](https://img.shields.io/pub/popularity/fancy_rating_dialog)](https://pub.dev/packages/fancy_rating_dialog/score)

A beautiful, highly customizable Flutter rating dialog with stunning gradients, animations, and glassmorphic effects.

## Features

✨ **Stunning Themes**
- 6 gorgeous pre-built gradient themes
  - Aurora
  - Sunset
  - Ocean
  - Forest
  - Midnight
  - Neon
- Glassmorphic background effects
- Smooth animations and transitions

🎨 **Rich Customization**
- Multiple rating modes (stars/emojis)
- Combined rating & review workflow
- Custom titles and messages
- Configurable max review length

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  fancy_rating_dialog: ^1.0.0
```

## Usage

```dart
void showRatingDialog() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => FancyRatingBar(
      theme: RatingThemes.aurora, // Choose from 6 beautiful themes
      ratingIconType: RatingIconType.stars, // stars or hearts
      useEmojiRating: false, // true for emoji rating
      mode: DialogMode.both, // rating, review, or both
      onSubmit: (data) async {
        print('Rating: ${data['rating']}');
        print('Review: ${data['review']}');
      },
    ),
  );
}
```

### Customization

```dart
FancyRatingBar(
  theme: RatingThemes.aurora,
  ratingIconType: RatingIconType.stars,
  useEmojiRating: false,
  mode: DialogMode.both,
  title: 'Custom Title',
  subtitle: 'Custom Subtitle',
  reviewTitle: 'Custom Review Title',
  reviewSubtitle: 'Custom Review Subtitle',
  maxLength: 500,
  onSubmit: (data) async {
    // Handle the rating and review
  },
)
```

## Available Themes

- `RatingThemes.aurora` - Purple and pink gradients
- `RatingThemes.sunset` - Orange and red gradients
- `RatingThemes.ocean` - Blue and cyan gradients
- `RatingThemes.forest` - Green and emerald gradients
- `RatingThemes.midnight` - Dark and elegant gradients
- `RatingThemes.neon` - Vibrant neon gradients

## Configuration Options

### Rating Icon Types
Available options for `ratingIconType`:

```dart
RatingIconType.stars    // ★ Default star icons
RatingIconType.hearts   // ♥ Heart icons
```

### Dialog Modes
Available options for `mode`:

```dart
DialogMode.rating  // Shows only the rating step
DialogMode.review  // Shows only the review step
DialogMode.both    // Shows both rating and review steps (default)
```

### Example Usage

```dart
FancyRatingBar(
  theme: RatingThemes.aurora,
  // Configure rating type
  ratingIconType: RatingIconType.hearts,  // Use hearts instead of stars
  
  // Configure dialog mode
  mode: DialogMode.both,  // Show both rating and review steps
  
  // Optional: Use emoji rating instead of icons
  useEmojiRating: true,  // Enable emoji rating mode
  
  onSubmit: (data) async {
    print('Rating: ${data['rating']}');
    print('Review: ${data['review']}');
  },
)
```

### Mode Behaviors

- **Rating Mode (`DialogMode.rating`)**: 
  - Shows only star/heart/emoji rating
  - Single step dialog
  - Quick rating submission

- **Review Mode (`DialogMode.review`)**:
  - Shows only review text field
  - Single step dialog
  - Focused on written feedback

- **Both Mode (`DialogMode.both`)**:
  - Two-step process
  - Rate first, then optional review
  - Progress bar shows completion
  - Can go back to change rating

## Screenshots

### Aurora Theme
![Aurora Rating View](screenshots/aurora1.png)
![Aurora Review View](screenshots/aurora2.png)
![Aurora Success View](screenshots/aurora3.png)

### Sunset Theme
![Sunset Rating View](screenshots/sunset1.png)
![Sunset Review View](screenshots/sunset2.png)
![Sunset Success View](screenshots/sunset3.png)

### Ocean Theme
![Ocean Rating View](screenshots/ocean1.png)
![Ocean Review View](screenshots/ocean2.png)
![Ocean Success View](screenshots/ocean3.png)

### Forest Theme
![Forest Rating View](screenshots/forest1.png)
![Forest Review View](screenshots/forest2.png)
![Forest Success View](screenshots/forest3.png)

### Midnight Theme
![Midnight Rating View](screenshots/midnight1.png)
![Midnight Review View](screenshots/midnight2.png)
![Midnight Success View](screenshots/midnight3.png)

### Neon Theme
![Neon Rating View](screenshots/neon1.png)
![Neon Review View](screenshots/neon2.png)
![Neon Success View](screenshots/neon3.png)

## Additional Features

- Smooth animations and transitions
- Progress bar for multi-step flows
- Hover effects and scaling animations
- Success state animations
- Beautiful gradient buttons
- Backdrop blur effects

## Contributing

Contributions are welcome! If you find a bug or want to add a feature, please raise an issue or submit a PR.

## License

```
MIT License

Copyright (c) 2024 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```