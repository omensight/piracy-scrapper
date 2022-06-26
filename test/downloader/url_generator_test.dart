import 'package:scrapper/downloader/url_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Generator can generate url in the first call', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlRandomizer = UrlGenerator(sample1: sample1, sample2: sample2);
    expect(urlRandomizer.getGeneratedUrl(),
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuaaaaaaaaa/v.mp4');
  });

  test('Generator can generate incremented url in the second call', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample1, sample2: sample2);
    urlGenerator.getGeneratedUrl();
    expect(urlGenerator.getGeneratedUrl(),
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuaaaaaaaab/v.mp4');
  });

  test('Generator can generate biq output at 901 iteration', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample1, sample2: sample2);
    for (int i = 0; i < 900; i++) {
      urlGenerator.getGeneratedUrl();
    }
    expect(urlGenerator.getGeneratedUrl(),
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuaaaaaabiq/v.mp4');
  });

  test('Generator can generate ba output at 27 iteration', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample1, sample2: sample2);
    for (int i = 0; i < 26; i++) {
      urlGenerator.getGeneratedUrl();
    }
    expect(urlGenerator.getGeneratedUrl(),
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuaaaaaaaba/v.mp4');
  });

  test('Calculate part gives biq with 900 input', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample1, sample2: sample2);

    expect(urlGenerator.calculateFillPart(900, 3), 'biq');
  });

  test('Calculate part gives b with 1 input', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample1, sample2: sample2);

    expect(urlGenerator.calculateFillPart(1, 1), 'b');
  });

  test('Calculate part gives ba with 26 input', () {
    const sample1 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    const sample2 =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutu34fqfligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample1, sample2: sample2);

    expect(urlGenerator.calculateFillPart(26, 2), 'ba');
  });

  test('Returns exception if both samples are equals', () {
    const sample =
        'https://10-ukr-sv.ennovelas.com/wlooo3ydopz54amjhxwiimwyg4qf4mhu5u6nuzi3c67badjzutuyqfifligq/v.mp4';
    final urlGenerator = UrlGenerator(sample1: sample, sample2: sample);
    expect(() => urlGenerator.getGeneratedUrl(),
        throwsA(const TypeMatcher<Exception>()));
  });
}
