import 'package:fancy_rating_bar/fancy_rating_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating Dialog Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      home: RatingDialogDemo(),
    );
  }
}

class RatingDialogDemo extends StatefulWidget {
  const RatingDialogDemo({super.key});

  @override
  State<RatingDialogDemo> createState() => _RatingDialogDemoState();
}

class _RatingDialogDemoState extends State<RatingDialogDemo> {
  RatingTheme currentTheme = RatingThemes.aurora;

  void _showRatingDialog() {
    FancyRatingBarParams fancyRatingBarParams = FancyRatingBarParams(
      theme: currentTheme,
      ratingIconType: RatingIconType.stars,
      useEmojiRating: false,
      playStoreUrl:
          "https://play.google.com/store/apps/details?id=com.example.app",
      appStoreUrl: "https://apps.apple.com/app/234567890",
      testMode: true,
    );
    FancyRatingBar.of(context).handleAutomaticRating(
      params: fancyRatingBarParams,
      onSubmit: (response) {
        debugPrint('Rating submitted: ${response.toJson()}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: currentTheme.background),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton<RatingTheme>(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: currentTheme.buttonGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.palette, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Themes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onSelected: (theme) {
                        setState(() {
                          currentTheme = theme;
                        });
                      },
                      itemBuilder: (context) => RatingThemes.allThemes
                          .map(
                            (theme) => PopupMenuItem<RatingTheme>(
                              value: theme,
                              child: Text(theme.name),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  Container(
                    decoration: BoxDecoration(
                      gradient: currentTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: currentTheme.accentColor,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Container(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showRatingDialog,
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Leave a Review',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
