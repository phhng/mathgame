class MathFunction {
  // To round up after points use .toStringAsFixed(2) to round up to 2 digits
  // To round up use .ceil() for positive, .floor() for negative
  // this.floor() : this.ceil();
  double addNumbers(double a, double b) {
    return a + b;
  }

  double multiplyNumbers(double a, double b){
    return a * b;
  }

  double substractNumbers(double a, double b){
    return a - b;
  }

  double divideNumbers(double a, double b){
    //when using this rmb to check b != 0
      return a / b;
  }

  bool checkAnswerInt(int a, int b) {
    return a == b;
  }
}