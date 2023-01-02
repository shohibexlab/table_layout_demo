import 'package:flutter/foundation.dart';

void logger(dynamic text, [String hint = "LOGGER"]) {
  if (kDebugMode) {
    print(hint);
    print(text);
    print(hint);
  }
}
