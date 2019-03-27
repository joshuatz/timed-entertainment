import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class UserSettings {
    // Members - Public:
    bool hasFavoriteSource = false;
    int favoriteSource = 0;
    /*
     * Global repeat
     *  allowRepeats vs neverAllowRepeats
     *      repeats can still be shown if allowRepeats=false, so long as neverAllowRepeats=false and the minElapsedBeforeRepeat <= elapsed
     *      if neverAllowRepeats == true, than a video can NEVER be repeated, no matter how much time has passed
     */
    bool allowRepeats = false;
    bool neverAllowRepeats = false;
    Duration minElapsedBeforeRepeat = Duration(days: 31);

    // Constructor
    UserSettings();
}