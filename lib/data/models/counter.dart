import 'package:scoped_model/scoped_model.dart';

class Counter extends Model {
  int counter = 0;

  void setCounterValue(int i) {
    counter = i;
    notifyListeners();
  }

  void incrementCounter() {
    counter += 1;
    print('Counter value : $counter');
    notifyListeners();
  }

  void decrementCounter() {
    counter -= 1;
    notifyListeners();
  }
}
