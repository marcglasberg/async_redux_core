import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  test('should create UserException with correct properties', () {
    const exception = UserException(
      'message',
      cause: 'cause',
      code: 123,
    );

    expect(exception.message, 'message');
    expect(exception.cause, 'cause');
    expect(exception.code, 123);
  });

  // Test all combinations:
  // 1) msg provided, cause NOT provided, code NOT provided
  // 2) msg NOT provided, cause provided, code NOT provided
  // 3) msg NOT provided, cause NOT provided, code provided
  // 4) msg provided, cause provided, code provided
  // 5) msg provided, cause provided, code NOT provided
  // 6) msg NOT provided, cause NOT provided, code NOT provided
  // 7) msg provided, cause NOT provided, code provided
  // 8) msg NOT provided, cause provided, code provided
  test('dialogTitle and dialogContent1', () {
    //
    // 1) - `msg` is provided
    //    - `cause` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    var exception = const UserException('message');
    expect(exception.titleAndContent(), ('', 'message'));

    // 2) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = const UserException(null, cause: 'cause');
    expect(exception.titleAndContent(), ('', 'cause'));

    // 3) - `msg` is NOT provided
    //    - `cause` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = const UserException(null, code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // 4) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = const UserException(
      'message',
      cause: 'cause',
      code: 123,
    );
    expect(exception.titleAndContent(), ('123', 'cause'));

    // 5) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `cause`
    //
    exception = const UserException('message', cause: 'cause');
    expect(exception.titleAndContent(), ('message', 'cause'));

    // 6) - `msg` is NOT provided
    //    - `cause` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    exception = const UserException(null);
    expect(exception.titleAndContent(), ('User Error', ''));

    // 7) - `msg` is provided
    //    - `cause` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `code`
    //    - Ignored: `msg`
    //
    exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // 8) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = const UserException(null, cause: 'cause', code: 123);
    expect(exception.titleAndContent(), ('123', 'cause'));
  });

  test('Added UserException cause, with msg only', () {
    //
    UserException.setLocale('en');
    var joinStr = UserException.defaultJoinString();

    // 1) - `msg` is provided
    //    - `cause` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    var exception = const UserException('message').addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('message', 'Extra'));

    // 2) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = const UserException(null, cause: 'cause').addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('cause', 'Extra'));

    // 3) - `msg` is NOT provided
    //    - `cause` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = const UserException(null, code: 123).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'Extra'));

    // 4) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = const UserException(
      'message',
      cause: 'cause',
      code: 123,
    ).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'cause${joinStr}Extra'));

    // 5) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `cause`
    //
    exception =
        const UserException('message', cause: 'cause').addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('message', 'cause${joinStr}Extra'));

    // 6) - `msg` is NOT provided
    //    - `cause` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    exception = const UserException(null).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('', 'Extra'));

    // 7) - `msg` is provided
    //    - `cause` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `code`
    //    - Ignored: `msg`
    //
    exception = const UserException('message', code: 123).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'Extra'));

    // 8) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception =
        const UserException(null, cause: 'cause', code: 123).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'cause${joinStr}Extra'));
  });

  test('The "Reason" text is translated to the current locale.', () {
    //
    // Spanish:

    UserException.setLocale('es');
    var joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Razón: ');

    // Portuguese

    UserException.setLocale('pt');
    joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Motivo: ');

    // English:

    UserException.setLocale('en');
    joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Reason: ');
  });

  test('The code is translated to the current locale using `codeTranslations`.', () {
    //
    UserException.codeTranslations = Translations.byId('en_us', {
      1: {
        'en_us': 'Code One',
        'pt': 'Código Um',
      },
      2: {
        'en_us': 'Code Two',
        'pt': 'Código Dois',
      },
    });

    // English:

    UserException.setLocale('en');

    // When there is no text translation associated with a code, the code itself is used.
    var exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // There is a text translation.
    exception = const UserException('message', code: 1);
    expect(exception.titleAndContent(), ('', 'Code One'));

    // There is a text translation.
    exception = const UserException('message', code: 2);
    expect(exception.titleAndContent(), ('', 'Code Two'));

    // Portuguese:

    UserException.setLocale('pt');

    // When there is no text translation associated with a code, the code itself is used.
    exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // There is a text translation.
    exception = const UserException('message', code: 1);
    expect(exception.titleAndContent(), ('', 'Código Um'));

    // There is a text translation.
    exception = const UserException('message', code: 2);
    expect(exception.titleAndContent(), ('', 'Código Dois'));

    // Unknown locale:

    UserException.setLocale('xx');

    // When there is no text translation associated with a code, the code itself is used.
    exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // Use the 'en_us' translation (specified here: `Translations.byId('en_us'`).
    exception = const UserException('message', code: 1);
    expect(exception.titleAndContent(), ('', 'Code One'));

    // Use the 'en_us' translation (specified here: `Translations.byId('en_us'`).
    exception = const UserException('message', code: 2);
    expect(exception.titleAndContent(), ('', 'Code Two'));

    UserException.codeTranslations = null;
  });

  test('The code is associated with a translation using `translateCode`.', () {
    //
    // The current language doesn't matter anymore, since we are using this
    // method to create the text from the code:
    UserException.translateCode = (int? code) => 'The code is $code';

    UserException.setLocale('en');

    var exception = const UserException('message', code: 1);
    expect(exception.titleAndContent(), ('', 'The code is 1'));

    exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', 'The code is 123'));

    UserException.setLocale('pt');

    exception = const UserException('message', code: 1);
    expect(exception.titleAndContent(), ('', 'The code is 1'));

    exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', 'The code is 123'));
  });
}
