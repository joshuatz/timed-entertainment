import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class UserSettings {
    // Members - Public:
    bool hasFavoriteSource = false;
    int favoriteSource = 0;
    // Global repeat settings
    bool allowRepeats = false;
    bool neverAllowRepeats = false;
    Duration minElapsedBeforeRepeat = Duration(days: 31);

    // Constructor
    UserSettings();
}