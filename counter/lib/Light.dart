import 'dart:async';

class Light {
  final _lightStream = StreamController<String>();

  void green() => _lightStream.sink.add("green");

  void red() => _lightStream.sink.add("red");

  void yellow() => _lightStream.sink.add("yellow");

  Stream<String> lightColor() => _lightStream.stream;

  void dispose() => _lightStream.close();

}