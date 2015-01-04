part of flurt;

class EventEmitter {

  Map<String, StreamController> _controllers = new Map<String, StreamController>();

  StreamController _createController(name) {
    var ctrl = new StreamController.broadcast(
        onListen: () {},
        onCancel: () {
          _controllers[name].close();
          off(name);
        },
        sync: true
    );
    _controllers[name] = ctrl;
    return _controllers[name];
  }

  Stream on(String name) {
    var ctrl;
    if (!_controllers.containsKey(name)) {
      ctrl = _createController(name);
    } else {
      ctrl = _controllers[name];
    }
    return ctrl.stream;
  }

  void off(String name) {
    if (_controllers.containsKey(name)) {
      _controllers.remove(name);
    }
  }

  void publish(String name, dynamic data) {
    var ctrl;
    if (_controllers.containsKey(name)) {
      ctrl = _controllers[name];
    } else {
      ctrl = _createController(name);
    }

    if (ctrl.isClosed) {
      return;
    }

    if (ctrl.hasListener && !ctrl.isPaused) {
      ctrl.add(data);
    }
  }
}
