import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  test('toString', () {
    expect(const UserException('').toString(), 'UserException{}');

    expect(const UserException('m').toString(), 'UserException{m}');

    expect(const UserException('m', reason: 'r').toString(), 'UserException{m|Reason: r}');

    expect(const UserException('', reason: 'r').toString(), 'UserException{r}');

    expect(
        const UserException('m', reason: 'r', code: 42).toString(), 'UserException{42|Reason: r}');

    expect(
        const UserException('', reason: 'r', code: 42).toString(), 'UserException{42|Reason: r}');

    expect(const UserException('m', reason: 'r', ifOpenDialog: false).toString(),
        'UserException{m|Reason: r, ifOpenDialog: false}');

    expect(const UserException('m', reason: 'r', ifOpenDialog: false, errorText: 'et').toString(),
        'UserException{m|Reason: r, ifOpenDialog: false, errorText: "et"}');

    expect(const UserException('m', reason: 'r', errorText: 'et').toString(),
        'UserException{m|Reason: r, errorText: "et"}');
  });

  test('Creates UserException with correct properties', () {
    var exception = const UserException(
      'message',
      reason: 'reason',
      code: 123,
    );

    expect(exception.message, 'message');
    expect(exception.reason, 'reason');
    expect(exception.code, 123);
    expect(exception.ifOpenDialog, true);
    expect(exception.errorText, isNull);

    // ---

    exception = const UserException(
      '',
      reason: 'reason',
      code: 123,
      errorText: 'my error text',
      ifOpenDialog: false,
    );

    expect(exception.message, '');
    expect(exception.reason, 'reason');
    expect(exception.code, 123);
    expect(exception.ifOpenDialog, false);
    expect(exception.errorText, 'my error text');

    exception = exception.withErrorText('my error text 2');
    expect(exception.errorText, 'my error text 2');

    exception = exception.withErrorText(null);
    expect(exception.errorText, isNull);

    // ---

    exception = const UserException(
      '',
      reason: '',
      errorText: 'my error text',
    ).noDialog;

    expect(exception.message, '');
    expect(exception.reason, '');
    expect(exception.code, isNull);
    expect(exception.ifOpenDialog, false);
    expect(exception.errorText, 'my error text');

    exception = exception.mergedWith(const UserException('Extra'));
    expect(exception.ifOpenDialog, false);
    expect(exception.errorText, 'my error text');

    exception = exception.addReason('Extra');
    expect(exception.ifOpenDialog, false);
    expect(exception.errorText, 'my error text');

    expect(exception.toString(),
        'UserException{Extra|Reason: Extra, ifOpenDialog: false, errorText: "my error text"}');

    // ---

    exception = const UserException('');
    expect(exception.ifOpenDialog, isTrue);
    exception = exception.mergedWith(const UserException('Extra'));
    expect(exception.ifOpenDialog, isTrue);
    exception = exception.mergedWith(const UserException('Extra', ifOpenDialog: false));
    expect(exception.ifOpenDialog, isFalse);

    exception = const UserException('', ifOpenDialog: false);
    expect(exception.ifOpenDialog, isFalse);
    exception = exception.mergedWith(const UserException('Extra', ifOpenDialog: true));
    expect(exception.ifOpenDialog, isFalse);

    // ---

    // null + null
    exception = const UserException('');
    exception = exception.mergedWith(const UserException('Extra'));
    expect(exception.errorText, isNull);

    // errorText
    exception = const UserException('', errorText: 'my error text');
    expect(exception.errorText, 'my error text');

    // errorText + null
    exception = exception.mergedWith(const UserException('Extra'));
    expect(exception.errorText, 'my error text');

    // errorText + errorText
    exception = exception.mergedWith(const UserException('Extra', errorText: 'another error text'));
    expect(exception.errorText, 'another error text');

    // null + errorText
    exception = const UserException('');
    exception =
        exception.mergedWith(const UserException('Extra', errorText: 'yet another error text'));
    expect(exception.errorText, 'yet another error text');
  });

  // Test all combinations:
  // 1) msg provided, reason NOT provided, code NOT provided
  // 2) msg NOT provided, reason provided, code NOT provided
  // 3) msg NOT provided, reason NOT provided, code provided
  // 4) msg provided, reason provided, code provided
  // 5) msg provided, reason provided, code NOT provided
  // 6) msg NOT provided, reason NOT provided, code NOT provided
  // 7) msg provided, reason NOT provided, code provided
  // 8) msg NOT provided, reason provided, code provided
  test('dialogTitle and dialogContent1', () {
    //
    // 1) - `msg` is provided
    //    - `reason` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    var exception = const UserException('message');
    expect(exception.titleAndContent(), ('', 'message'));

    // 2) - `msg` is NOT provided
    //    - `reason` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `reason`
    //
    exception = const UserException(null, reason: 'reason');
    expect(exception.titleAndContent(), ('', 'reason'));

    // 3) - `msg` is NOT provided
    //    - `reason` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `reason`
    //
    exception = const UserException(null, code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // 4) - `msg` is provided
    //    - `reason` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `reason`
    //    - Ignored: `msg`
    //
    exception = const UserException(
      'message',
      reason: 'reason',
      code: 123,
    );
    expect(exception.titleAndContent(), ('123', 'reason'));

    // 5) - `msg` is provided
    //    - `reason` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `reason`
    //
    exception = const UserException('message', reason: 'reason');
    expect(exception.titleAndContent(), ('message', 'reason'));

    // 6) - `msg` is NOT provided
    //    - `reason` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    exception = const UserException(null);
    expect(exception.titleAndContent(), ('User Error', ''));

    // 7) - `msg` is provided
    //    - `reason` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `code`
    //    - Ignored: `msg`
    //
    exception = const UserException('message', code: 123);
    expect(exception.titleAndContent(), ('', '123'));

    // 8) - `msg` is NOT provided
    //    - `reason` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `reason`
    //    - Ignored: `msg`
    //
    exception = const UserException(null, reason: 'reason', code: 123);
    expect(exception.titleAndContent(), ('123', 'reason'));
  });

  test('Added reason', () {
    //
    UserException.setLocale('en');
    var joinStr = UserException.defaultJoinString();

    // 1) - `msg` is provided
    //    - `reason` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    var exception = const UserException('message').addReason('Extra');
    expect(exception.titleAndContent(), ('message', 'Extra'));

    // 2) - `msg` is NOT provided
    //    - `reason` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `reason`
    //
    exception = const UserException(null, reason: 'reason').addReason('Extra');
    expect(exception.titleAndContent(), ('reason', 'Extra'));

    // 3) - `msg` is NOT provided
    //    - `reason` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `reason`
    //
    exception = const UserException(null, code: 123).addReason('Extra');
    expect(exception.titleAndContent(), ('123', 'Extra'));

    // 4) - `msg` is provided
    //    - `reason` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `reason`
    //    - Ignored: `msg`
    //
    exception = const UserException(
      'message',
      reason: 'reason',
      code: 123,
    ).addReason('Extra');
    expect(exception.titleAndContent(), ('123', 'reason${joinStr}Extra'));

    // 5) - `msg` is provided
    //    - `reason` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `reason`
    //
    exception = const UserException('message', reason: 'reason').addReason('Extra');
    expect(exception.titleAndContent(), ('message', 'reason${joinStr}Extra'));

    // 6) - `msg` is NOT provided
    //    - `reason` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    exception = const UserException(null).addReason('Extra');
    expect(exception.titleAndContent(), ('', 'Extra'));

    // 7) - `msg` is provided
    //    - `reason` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `code`
    //    - Ignored: `msg`
    //
    exception = const UserException('message', code: 123).addReason('Extra');
    expect(exception.titleAndContent(), ('123', 'Extra'));

    // 8) - `msg` is NOT provided
    //    - `reason` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `reason`
    //    - Ignored: `msg`
    //
    exception = const UserException(null, reason: 'reason', code: 123).addReason('Extra');
    expect(exception.titleAndContent(), ('123', 'reason${joinStr}Extra'));
  });

  test('Merged UserException', () {
    //
    UserException.setLocale('en');
    var joinStr = UserException.defaultJoinString();

    // 1) - `msg` is provided
    //    - `reason` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    var exception = const UserException('message').mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('message', 'Extra'));

    // 2) - `msg` is NOT provided
    //    - `reason` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `reason`
    //
    exception =
        const UserException(null, reason: 'reason').mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('reason', 'Extra'));

    // 3) - `msg` is NOT provided
    //    - `reason` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `reason`
    //
    exception = const UserException(null, code: 123).mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'Extra'));

    // 4) - `msg` is provided
    //    - `reason` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `reason`
    //    - Ignored: `msg`
    //
    exception = const UserException(
      'message',
      reason: 'reason',
      code: 123,
    ).mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'reason${joinStr}Extra'));

    // 5) - `msg` is provided
    //    - `reason` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `reason`
    //
    exception =
        const UserException('message', reason: 'reason').mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('message', 'reason${joinStr}Extra'));

    // 6) - `msg` is NOT provided
    //    - `reason` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    exception = const UserException(null).mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('', 'Extra'));

    // 7) - `msg` is provided
    //    - `reason` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `code`
    //    - Ignored: `msg`
    //
    exception = const UserException('message', code: 123).mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'Extra'));

    // 8) - `msg` is NOT provided
    //    - `reason` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `reason`
    //    - Ignored: `msg`
    //
    exception = const UserException(null, reason: 'reason', code: 123)
        .mergedWith(const UserException('Extra'));
    expect(exception.titleAndContent(), ('123', 'reason${joinStr}Extra'));
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
    UserException.codeTranslations = Translations.byId('en-US', {
      1: {
        'en-US': 'Code One',
        'pt': 'Código Um',
      },
      2: {
        'en-US': 'Code Two',
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

    // Use the 'en-US' translation (specified here: `Translations.byId('en_us'`).
    exception = const UserException('message', code: 1);
    expect(exception.titleAndContent(), ('', 'Code One'));

    // Use the 'en-US' translation (specified here: `Translations.byId('en_us'`).
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
