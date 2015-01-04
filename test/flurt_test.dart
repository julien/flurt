import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:flurt/flurt.dart';
import 'dart:html';

void main() {
  useHtmlEnhancedConfiguration();

  group('Dispatcher', () {

    var dispatcher = new Dispatcher();
    var ref;
    var cb = (String val) => ref = val;

    test('should return an "id" when registering a callback', () {
      expect(dispatcher.register(cb), equals('id_1'));
    });

    test('should return a different id each time', () {
      expect(dispatcher.register(cb), equals('id_2'));
      expect(dispatcher.register(cb), equals('id_3'));
      expect(dispatcher.register(cb), equals('id_4'));
    });

    test('should unregister an existing callback', () {
      expect(dispatcher.unregister('id_2'), isNotNull);
      expect(dispatcher.unregister('id_3'), isNotNull);
      expect(dispatcher.unregister('id_4'), isNotNull);
    });

    test('should not unregister a non existing callback', () {
      expect(dispatcher.unregister('id_2'), isNull);
      expect(dispatcher.unregister('id_3'), isNull);
      expect(dispatcher.unregister('id_4'), isNull);
    });

    test('should invoke callbacks when dispatch is invoked', () {
      dispatcher.dispatch('test 1');
      expect(ref, equals('test 1'));

      dispatcher.dispatch('test 2');
      expect(ref, equals('test 2'));
    });

    test('should not invoke callbacks if none are registered', () {
      dispatcher.unregister('id_1');

      ref = 'test 0';
      dispatcher.dispatch('test 1');
      expect(ref, equals('test 0'));
    });

    test('should return a list of callback ids', () {
      expect(dispatcher.callbackIds.length, equals(0));
      dispatcher.register(cb);
      expect(dispatcher.callbackIds.length, equals(1));
    });
  });

  group('EventEmitter', () {

    var emitter = new EventEmitter();
    var ref;

    test('should register listeners with "on"', () {
      var ctrl = emitter.on('test:event').listen(null);
      ctrl.onData((String val) {
        ref = val;
        expect(val, equals('something'));
      });
      emitter.publish('test:event', 'something');
    });

    test('should unregister listeners with "off"', () {
      emitter.off('test:event');
      emitter.publish('test:event', 'something else');
      expect(ref, equals('something'));
    });
  });
}
