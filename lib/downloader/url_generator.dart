class UrlGenerator {
  final String sample1;
  final String sample2;
  int _timesRequested = 0;
  int _equalitySize = 0;
  int _lastSlashIndex = 0;
  int _availableSpacesForGeneration = 0;
  UrlGenerator({required this.sample1, required this.sample2}) {
    if (sample1.length == sample2.length) {
      bool equalitySizeSettled = false;
      for (int i = 0; i < sample1.length; i++) {
        if (sample1[i] != sample2[i] && !equalitySizeSettled) {
          _equalitySize = i;
          equalitySizeSettled = true;
        }
        if (sample1[i] == '/') {
          _lastSlashIndex = i;
        }
      }
      _availableSpacesForGeneration = _lastSlashIndex - _equalitySize;
    }
  }

  String getGeneratedUrl() {
    if (sample1 == sample2) {
      throw Exception('Two samples are the same');
    }
    String generatedPart =
        calculateFillPart(_timesRequested, _availableSpacesForGeneration);
    _timesRequested++;
    return '${sample1.substring(0, _equalitySize)}$generatedPart/v.mp4';
  }

  String calculateFillPart(int number, int maxSpaces) {
    String calculated = '';
    String alphabet = 'abcdefghijklmnopqrstuvwxyz';
    int copiedNumber = number;
    int ocuppiedSpaces = 0;
    do {
      int indexOfCurrentDigit = (copiedNumber % 26);

      calculated += alphabet[indexOfCurrentDigit];
      copiedNumber ~/= 26;
      ocuppiedSpaces++;
    } while (copiedNumber > 0);
    calculated += 'a' * (maxSpaces - ocuppiedSpaces);
    calculated = calculated.split('').reversed.join('');

    return calculated;
  }
}
