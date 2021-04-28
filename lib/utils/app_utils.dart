/// this class exposes utility methods
class AppUtils {
  static void logMsg(Object obj, String msg) {
    var className = obj.runtimeType.toString();
    className = className == 'String' ? obj as String : className;
    print('$className msg : $msg');
  }
}
