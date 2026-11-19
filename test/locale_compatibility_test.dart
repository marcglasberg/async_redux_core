import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() {
    UserException.codeTranslations = null;
    UserException.setLocale(null);
  });

  test(
    'exception codes share translations and pt-BR locale with i18n core',
    () {
      UserException.codeTranslations = Translations.byId<int>('en', {
        7: {'en': 'Connection unavailable', 'pt': 'Sem conexão'},
      });
      DefaultLocale.set('pt_BR');
      expect(UserException.translateCode(7), 'Sem conexão');
      DefaultLocale.set('en_US');
      expect(UserException.translateCode(7), 'Connection unavailable');
    },
  );
}
