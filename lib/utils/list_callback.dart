import 'package:events_emitter/events_emitter.dart';

// ignore: avoid_classes_with_only_static_members
/// ## ListCallback
/// 
/// ListCallback is a helper class to create callbacks with multiple arguments.
/// 
/// Converts a normal event of type `List<dynamic>` into its individual arguments,
/// which it then validates each argument type before calling the callback.
/// 
/// ```dart
/// final emitter = EventEmitter();
/// 
/// emitter.on('message', ListCallback.args2((String text, int number) {
///   print('String: $text, Number: $number');
/// }));
/// 
/// emitter.emit('message', ['Hello World', 123]);
/// ```
class ListCallback {
  static EventCallback<List<dynamic>> args1<T1>(
    dynamic Function(T1 data1) callback,
  ) => (data) {
    if (_validate<T1, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1);
    }
    return false;
  };

  static EventCallback<List<dynamic>> args2<T1, T2>(
    dynamic Function(T1 data1, T2 data2) callback,
  ) => (data) {
    if (_validate<T1, T2, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args3<T1, T2, T3>(
    dynamic Function(T1 data1, T2 data2, T3 data3) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args4<T1, T2, T3, T4>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args5<T1, T2, T3, T4, T5>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, T5, dynamic, dynamic, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4, data[4] as T5);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args6<T1, T2, T3, T4, T5, T6>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5, T6 data6) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, T5, T6, dynamic, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4, data[4] as T5, data[5] as T6);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args7<T1, T2, T3, T4, T5, T6, T7>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5, T6 data6, T7 data7) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, T5, T6, T7, dynamic, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4, data[4] as T5, data[5] as T6, data[6] as T7);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args8<T1, T2, T3, T4, T5, T6, T7, T8>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5, T6 data6, T7 data7, T8 data8) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, T5, T6, T7, T8, dynamic, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4, data[4] as T5, data[5] as T6, data[6] as T7, data[7] as T8);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args9<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5, T6 data6, T7 data7, T8 data8, T9 data9) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, T5, T6, T7, T8, T9, dynamic>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4, data[4] as T5, data[5] as T6, data[6] as T7, data[7] as T8, data[8] as T9);
    }
    return false;
  };
  
  static EventCallback<List<dynamic>> args10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    dynamic Function(T1 data1, T2 data2, T3 data3, T4 data4, T5 data5, T6 data6, T7 data7, T8 data8, T9 data9, T10 data10) callback,
  ) => (data) {
    if (_validate<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(data)) {
      return callback(data[0] as T1, data[1] as T2, data[2] as T3, data[3] as T4, data[4] as T5, data[5] as T6, data[6] as T7, data[7] as T8, data[8] as T9, data[9] as T10);
    }
    return false;
  };

  static List<dynamic> emit([ dynamic data1, dynamic data2, dynamic data3, dynamic data4, dynamic data5, dynamic data6, dynamic data7, dynamic data8, dynamic data9, dynamic data10 ]) =>
    [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10];

  /* -= Helper Methods =- */
  
  static bool _validate<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(List<dynamic> data) {
    return
      _getDataAt(data, 0) is T1 &&
      _getDataAt(data, 1) is T2 &&
      _getDataAt(data, 2) is T3 &&
      _getDataAt(data, 3) is T4 &&
      _getDataAt(data, 4) is T5 &&
      _getDataAt(data, 5) is T6 &&
      _getDataAt(data, 6) is T7 &&
      _getDataAt(data, 7) is T8 &&
      _getDataAt(data, 8) is T9 &&
      _getDataAt(data, 9) is T10;
  }

  static dynamic _getDataAt(List<dynamic> data, int index) {
    if (data.length <= index) return null;
    return data[index];
  }
}
