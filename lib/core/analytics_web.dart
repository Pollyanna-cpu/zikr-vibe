import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('gtag')
external JSFunction? get _gtag;

void gtagEvent(String name, Map<String, Object?> params) {
  final fn = _gtag;
  if (fn == null) return;
  final obj = JSObject();
  params.forEach((k, v) {
    if (v == null) return;
    if (v is String) obj[k] = v.toJS;
    else if (v is num) obj[k] = v.toJS;
    else if (v is bool) obj[k] = v.toJS;
    else obj[k] = v.toString().toJS;
  });
  fn.callAsFunction(null, 'event'.toJS, name.toJS, obj);
}
