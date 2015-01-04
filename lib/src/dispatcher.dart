part of flurt;

class Dispatcher {

  int _lastId = 1;
  String _prefix = 'id_';
  Map<String, Function> _callbacks = new Map<String, Function>();
  Map<String, bool> _isPending = new Map<String, bool>();
  Map<String, bool> _isHandled = new Map<String, bool>();
  bool _dispatching = false;
  Object _pendingPayload;

  String register(Function callback) {
    var id = '${_prefix}${_lastId++}';
    _callbacks[id] = callback;
    return id;
  }

  void unregister(String id) => _callbacks.remove(id);

  void waitFor(List<String> ids) {
    ids.forEach((String id) {
      if (!_isPending[id]) {
        _invokeCallback(id);
      }
    });
  }

  void dispatch(Object payload) {
    if (_dispatching) {
      return;
    }
    // Original implementation
    // has a try/catch block here
    _startDispatching(payload);

    _callbacks.forEach((String id, Function fn) {
      if (!_isPending[id]) {
        _invokeCallback(id);
      }
    });

    _stopDispatching();
  }

  bool get dispatching => _dispatching;

  void _invokeCallback(String id) {
    _isPending[id] = true;
    _callbacks[id](_pendingPayload);
    _isHandled[id] = true;
  }

  void _startDispatching(Object payload) {
    _callbacks.forEach((String id, Function fn) {
      _isPending[id] = false;
      _isHandled[id] = false;
    });
    _pendingPayload = payload;
    _dispatching = true;
  }

  void _stopDispatching() {
    _pendingPayload = null;
    _dispatching = false;
  }

  List<String> get callbackIds => _callbacks.keys;

}
