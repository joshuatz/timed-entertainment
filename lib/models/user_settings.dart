import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class UserSettings {
    // Members - Public:
    bool hasFavoriteSource;
    int favoriteSource = 0;

    // Constructor
    UserSettings(this.hasFavoriteSource,this.favoriteSource);
}