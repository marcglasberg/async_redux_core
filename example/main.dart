import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';

void main() {
  // 1) The UserException can produce its own title and content to be used in UIs
  // such as dialogs, toasts etc.

  var exception = const UserException('Invalid email', cause: 'Must have at least 5 characters.');
  var (title, content) = exception.titleAndContent();

  // Should print "Invalid email / Must have at least 5 characters."
  print('$title / $content');

  // ---

  // 2) The UserException can also be created with a code, which can be used to
  // translate the error message to the current locale.

  exception = UserException('', code: MyCode(1));

  UserException.setLocale('en');
  (title, content) = exception.titleAndContent();
  print('In English: $content'); // Should print "Invalid email"

  UserException.setLocale('pt');
  (title, content) = exception.titleAndContent();
  print('In Portuguese: $content'); // Should print "Email inválido"

  // ---

  exception = UserException('', code: MyCode(2));

  UserException.setLocale('en');
  (title, content) = exception.titleAndContent();
  print('In English: $content'); // Should print "There is no connection"

  UserException.setLocale('pt');
  (title, content) = exception.titleAndContent();
  print('In Portuguese: $content'); // Should print "Não há conexão"
}

class MyCode extends ExceptionCode {
  final int code;

  MyCode(this.code);

  @override
  String? asText() => i18n;

  @override
  String toString() => 'MyCode{code: $code}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyCode && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

extension MyLocalization on Object {
  static final _t = Translations.byId('en', {
    MyCode(1): {
      'en': 'Invalid email',
      'pt': 'Email inválido',
    },
    MyCode(2): {
      'en': 'There is no connection',
      'pt': 'Não há conexão',
    },
  });

  String get i18n => localize(this, _t);
}
