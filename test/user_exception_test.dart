import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  test('should create UserException with correct properties', () {
    final exception = UserException(
      'message',
      cause: 'cause',
      code: SomeCode(),
    );

    expect(exception.message, 'message');
    expect(exception.cause, 'cause');
    expect(exception.code, isA<SomeCode>());
    expect(exception.code!.asText(), 'Some Code');
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
    exception = UserException(null, code: SomeCode());
    expect(exception.titleAndContent(), ('', 'Some Code'));

    // 4) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(
      'message',
      cause: 'cause',
      code: SomeCode(),
    );
    expect(exception.titleAndContent(), ('Some Code', 'cause'));

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
    exception = UserException('message', code: SomeCode());
    expect(exception.titleAndContent(), ('', 'Some Code'));

    // 8) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(null, cause: 'cause', code: SomeCode());
    expect(exception.titleAndContent(), ('Some Code', 'cause'));
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
    exception = UserException(null, code: SomeCode()).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('Some Code', 'Extra'));

    // 4) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(
      'message',
      cause: 'cause',
      code: SomeCode(),
    ).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('Some Code', 'cause${joinStr}Extra'));

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
    exception = UserException('message', code: SomeCode()).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('Some Code', 'Extra'));

    // 8) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(null, cause: 'cause', code: SomeCode())
        .addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('Some Code', 'cause${joinStr}Extra'));
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

    var exception = UserException('message', code: SomeCode());
    expect(exception.titleAndContent(), ('', 'Um Código'));

    exception = UserException('message', code: MyCode(1));
    expect(exception.titleAndContent(), ('', 'Código Um'));

    exception = UserException('message', code: MyCode(2));
    expect(exception.titleAndContent(), ('', 'Código Dois'));

    // English:

    UserException.setLocale('en');
    joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Reason: ');

    exception = UserException('message', code: SomeCode());
    expect(exception.titleAndContent(), ('', 'Some Code'));

    exception = UserException('message', code: MyCode(1));
    expect(exception.titleAndContent(), ('', 'Code One'));

    exception = UserException('message', code: MyCode(2));
    expect(exception.titleAndContent(), ('', 'Code Two'));
  });
}

class SomeCode extends ExceptionCode {
  @override
  String? asText() => 'Some Code'.i18n;
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

extension SomeLocalization on String {
  static final _t = Translations.byText('en_us') +
      {
        'en_us': 'Some Code',
        'pt': 'Um Código',
      };

  String get i18n => localize(this, _t);
}

extension MyLocalization on Object {
  static final _t = Translations.byId('en_us', {
    MyCode(1): {
      'en_us': 'Code One',
      'pt': 'Código Um',
    },
    MyCode(2): {
      'en_us': 'Code Two',
      'pt': 'Código Dois',
    },
  });

  String get i18n => localize(this, _t);
}
