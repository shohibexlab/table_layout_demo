import 'package:flutter/foundation.dart';

void logger(dynamic text) {
  if (kDebugMode) {
    print("LOGGER");
    print(text);
    print("LOGGER");
  }
}
