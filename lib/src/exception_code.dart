// Developed by Marcelo Glasberg (2024) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/async_redux_core

/// The code of some error.
/// For example, "invalid_email", "invalid_password", "no_connection" etc.
///
/// Method [asText] should return the text of the error message in the current locale.
/// For example "Invalid email", "Invalid password", "There is no connection" etc.
///
/// Note: You can translate the error messages in any way you want,
/// but we recommend you use the `i18n_extension_core` package
/// from https://pub.dev/packages/i18n_extension_core, or its Flutter brother
/// `i18n_extension` from https://pub.dev/packages/i18n_extension, which work by
/// appending `.i18n` to the code text or the code itself:
///
/// ```dart
/// // If you want to use the English text as the translation key.
/// String? asText() => 'There is no connection'.i18n;
///
/// OR
///
/// // If you want to use the code itself as the translation key.
/// String? asText() => i18n;
/// ```
///
/// Example:
///
/// ```dart
/// class MyExceptionCode extends ExceptionCode {
///   final int codeNumber;
///   MyExceptionCode(this.codeNumber);
///
///   String? asText() => i18n;
///
///   String toString() => 'MyExceptionCode{codeNumber: $codeNumber}';
///
///   bool operator ==(Object other) => identical(this, other) ||
///       other is AnotherTestExceptionCode && runtimeType == other.runtimeType && codeNumber == other.codeNumber;
///
///   int get hashCode => codeNumber.hashCode;
/// }
/// ```
///
/// If you translate the error messages with the `i18n_extension_core` package:
///
/// ```dart
/// extension MyLocalization on Object {
///   static final _t = Translations.byId('en_us', {
///     MyExceptionCode(1): {
///       'en_us': "Code One",
///       'pt': "Código Um",
///     },
///     MyExceptionCode(2): {
///       'en_us': "Code Two",
///       'pt': "Código Dois",
///     },
///   });
///
///   String get i18n => localize(this, _t);
/// }
/// ```
///
abstract class ExceptionCode {
  const ExceptionCode();

  /// Return the text of the error message in the current locale. For example "Invalid email",
  /// "Invalid password", "There is no connection" etc.
  ///
  /// Note: You can translate the error messages in any way you want,
  /// but we recommend you use the `i18n_extension_core` package
  /// from https://pub.dev/packages/i18n_extension_core, or its Flutter brother `i18n_extension`
  /// from https://pub.dev/packages/i18n_extension, which work by appending `.i18n` to the
  /// code text or the code itself:
  ///
  /// ```dart
  /// // If you want to use the English text as the translation key.
  /// String? asText() => 'There is no connection'.i18n;
  ///
  /// OR
  ///
  /// // If you want to use the code itself as the translation key.
  /// String? asText() => i18n;
  /// ```
  String? asText();
}
