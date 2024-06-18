import 'package:flutter/material.dart';

class FutureSignal<T> extends ChangeNotifier {
  FutureSignal(this.future) {
    future.then(onValue);
    future.whenComplete(onComplete);
  }

  final Future<T> future;

  T? data;
  bool isLoading = true;

  void onValue(T? value) {
    data = value;
    notifyListeners();
  }

  void onComplete() {
    isLoading = false;
    notifyListeners();
  }
}
