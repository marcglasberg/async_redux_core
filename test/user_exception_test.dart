import 'package:async_redux_core/async_redux_core.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  test('should create UserException with correct properties', () {
    final exception = UserException(
      'My message',
      cause: 'My cause',
      code: SomeExceptionCode(),
    );

    expect(exception.message, 'My message');
    expect(exception.cause, 'My cause');
    expect(exception.code, isA<SomeExceptionCode>());
    expect(exception.code!.asText(), 'My code');
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
    var exception = const UserException('My message');
    expect(exception.titleAndContent(), ('', 'My message'));

    // 2) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = const UserException(null, cause: 'My cause');
    expect(exception.titleAndContent(), ('', 'My cause'));

    // 3) - `msg` is NOT provided
    //    - `cause` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = UserException(null, code: SomeExceptionCode());
    expect(exception.titleAndContent(), ('', 'My code'));

    // 4) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(
      'My message',
      cause: 'My cause',
      code: SomeExceptionCode(),
    );
    expect(exception.titleAndContent(), ('My code', 'My cause'));

    // 5) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `cause`
    //
    exception = const UserException('My message', cause: 'My cause');
    expect(exception.titleAndContent(), ('My message', 'My cause'));

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
    exception = UserException('My message', code: SomeExceptionCode());
    expect(exception.titleAndContent(), ('', 'My code'));

    // 8) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(null, cause: 'My cause', code: SomeExceptionCode());
    expect(exception.titleAndContent(), ('My code', 'My cause'));
  });

  test('Added UserException cause, with msg only', () {
    //
    DefaultLocale.set("en");
    var joinStr = UserException.defaultJoinString();

    // 1) - `msg` is provided
    //    - `cause` is NOT provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `msg`
    //
    var exception = const UserException('My message').addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My message', 'Extra'));

    // 2) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception = const UserException(null, cause: 'My cause').addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My cause', 'Extra'));

    // 3) - `msg` is NOT provided
    //    - `cause` is NOT provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: NÃO TEM
    //    - Dialog content: `cause`
    //
    exception =
        UserException(null, code: SomeExceptionCode()).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My code', 'Extra'));

    // 4) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(
      'My message',
      cause: 'My cause',
      code: SomeExceptionCode(),
    ).addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My code', 'My cause${joinStr}Extra'));

    // 5) - `msg` is provided
    //    - `cause` is provided
    //    - `code` is NOT provided
    // Then:
    //    - Dialog title: `msg`
    //    - Dialog content: `cause`
    //
    exception =
        const UserException('My message', cause: 'My cause').addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My message', 'My cause${joinStr}Extra'));

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
    exception = UserException('My message', code: SomeExceptionCode())
        .addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My code', 'Extra'));

    // 8) - `msg` is NOT provided
    //    - `cause` is provided
    //    - `code` is provided
    // Then:
    //    - Dialog title: `code`
    //    - Dialog content: `cause`
    //    - Ignored: `msg`
    //
    exception = UserException(null, cause: 'My cause', code: SomeExceptionCode())
        .addCause(const UserException('Extra'));
    expect(exception.titleAndContent(), ('My code', 'My cause${joinStr}Extra'));
  });

  test('The "Reason" text is translated to the current locale.', () {
    //
    // Spanish:

    DefaultLocale.set("es");
    var joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Razón: ');

    // Portuguese

    DefaultLocale.set("pt");
    joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Motivo: ');

    var exception = UserException('My message', code: SomeExceptionCode());
    expect(exception.titleAndContent(), ('', 'Meu código'));

    exception = UserException('My message', code: MyExceptionCode(1));
    expect(exception.titleAndContent(), ('', 'Código Um'));

    exception = UserException('My message', code: MyExceptionCode(2));
    expect(exception.titleAndContent(), ('', 'Código Dois'));

    // English:

    DefaultLocale.set("en");
    joinStr = UserException.defaultJoinString();
    expect(
        joinStr,
        '\n'
        '\n'
        'Reason: ');

    exception = UserException('My message', code: SomeExceptionCode());
    expect(exception.titleAndContent(), ('', 'My code'));

    exception = UserException('My message', code: MyExceptionCode(1));
    expect(exception.titleAndContent(), ('', 'Code One'));

    exception = UserException('My message', code: MyExceptionCode(2));
    expect(exception.titleAndContent(), ('', 'Code Two'));
  });
}

class SomeExceptionCode extends ExceptionCode {
  @override
  String? asText() => 'My code'.i18n;
}

class MyExceptionCode extends ExceptionCode {
  final int codeNumber;

  MyExceptionCode(this.codeNumber);

  @override
  String? asText() => i18n;

  @override
  String toString() => 'MyExceptionCode{codeNumber: $codeNumber}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyExceptionCode &&
          runtimeType == other.runtimeType &&
          codeNumber == other.codeNumber;

  @override
  int get hashCode => codeNumber.hashCode;
}

extension SomeLocalization on String {
  static final _t = Translations.byText('en_us') +
      {
        "en_us": "My code",
        "pt": "Meu código",
      };

  String get i18n => localize(this, _t);
}

extension MyLocalization on Object {
  static final _t = Translations.byId('en_us', {
    MyExceptionCode(1): {
      'en_us': "Code One",
      'pt': "Código Um",
    },
    MyExceptionCode(2): {
      'en_us': "Code Two",
      'pt': "Código Dois",
    },
  });

  String get i18n => localize(this, _t);
}
