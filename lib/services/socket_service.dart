

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService(){
    this._initConfig();
  }

  void _initConfig() {

    this._socket = IO.io('http://192.168.1.203:3000/', IO.OptionBuilder()
      .setTransports(['websocket'])
      .enableAutoConnect()
      .build()
    );
    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // socket.on('new-message', (payload) {
    //   print('name: ' + payload['name']);
    //   print('message: ' + payload['message']);
    //   print(payload.containsKey('message2') ? payload['message2'] : 'no message2');
    // });
    // socket.on('fromServer', (_) => print(_));

  }

}