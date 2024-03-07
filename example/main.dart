import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';

void main() {
  UserException.codeTranslations = Translations.byId<int>('en', {
    1: {
      'en': 'Invalid email',
      'pt': 'Email inválido',
    },
    2: {
      'en': 'There is no connection',
      'pt': 'Não há conexão',
    },
  });

  // 1) The UserException can produce its own title and content to be used in UIs
  // such as dialogs, toasts etc.

  var exception = const UserException('Invalid email', reason: 'Must have at least 5 characters.');
  var (title, content) = exception.titleAndContent();

  // Should print: 'title: "Invalid email", content: "Must have at least 5 characters."'
  print('title: "$title", content: "$content"');

  // ---

  // 2) The UserException can also be created with a code, which can be used to
  // translate the error message to the current locale.

  exception = const UserException('', code: 1);

  UserException.setLocale('en');
  (title, content) = exception.titleAndContent();
  print('In English: "$content"'); // Should print "Invalid email"

  UserException.setLocale('pt');
  (title, content) = exception.titleAndContent();
  print('In Portuguese: "$content"'); // Should print "Email inválido"

  // ---

  exception = const UserException('', code: 2);

  UserException.setLocale('en');
  (title, content) = exception.titleAndContent();
  print('In English: "$content"'); // Should print "There is no connection"

  UserException.setLocale('pt');
  (title, content) = exception.titleAndContent();
  print('In Portuguese: "$content"'); // Should print "Não há conexão"
}
