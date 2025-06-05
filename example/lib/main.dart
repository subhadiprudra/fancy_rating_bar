import 'package:flutter/material.dart';
import 'package:fancy_rating_bar/fancy_rating_bar.dart';
import 'package:fancy_rating_bar/models/dialog_mode.dart';
import 'package:fancy_rating_bar/models/rating_icon.dart';
import 'package:fancy_rating_bar/models/rating_theme.dart';

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
  RatingIconType ratingType = RatingIconType.stars;
  bool useEmojis = false;
  DialogMode dialogMode = DialogMode.both;

  void _showRatingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => FancyRatingBar(
        theme: currentTheme,
        ratingIconType: ratingType,
        useEmojiRating: useEmojis,
        mode: dialogMode,
        onSubmit: (data) async {
          debugPrint(
            'Rating submitted: $data',
          ); // Changed from print to debugPrint
          await Future.delayed(const Duration(milliseconds: 1500));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: currentTheme.background),
        child: SafeArea(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
