// Developed by Marcelo Glasberg (2024) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/async_redux_core

import 'package:async_redux_core/src/user_exception_i18n.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';

/// The [UserException] represents an error the user could fix, like wrong typed
/// text, or missing internet connection.
///
/// Async Redux will capture [UserException]s to show them in dialogs
/// created with `UserExceptionDialog` or other UI you define in your widget
/// tree (see the explanation in the docs).
///
/// An [UserException] may have a [message] or an error [code] (if you provide
/// both, the message will be ignored), as well as an optional [reason], which
/// is a more specific text that explains why the exception happened. For example:
///
/// ```dart
/// throw UserException('Invalid email', reason: 'Must have at least 5 characters.');
/// ```
///
/// Method [titleAndContent] returns the title and content used in the error dialog.
/// If the exception has both a [message] an a [reason], the title will be
/// the [message], and its content will be the [reason]. Otherwise, the title
/// will be empty, and the content will be the [message].
///
/// Alternatively, if you provide a numeric [code] instead of a [message].
/// In this case, the message of the exception will be the one associated with
/// the code (see [translateCode] and [codeTranslations]) for more details.
///
/// ---
///
/// You can define a special Matcher for your UserException, to use in your
/// tests. Create a test lib with this code:
///
/// ```
/// import 'package:matcher/matcher.dart';
/// const Matcher throwsUserException = Throws(const TypeMatcher<UserException>());
/// ```
///
/// Then use it in your tests:
/// ```
/// expect(() => someFunction(), throwsUserException);
/// ```
///
/// Note: [UserException] is immutable.
///
class UserException implements Exception {
  /// Some message shown to the user.
  final String? message;

  /// Optionally, instead of [message] we may provide a numeric [code].
  /// This code may have an associated message which is set in the client.
  final int? code;

  /// Another text which is the reason of the user-exception.
  final String? reason;

  /// Creates a [UserException], given a message [message] of type String,
  /// a [reason] of type String or [UserException], and an optional numeric [code].
  /// All fields are optional, but usually at least the [message] or [code] is provided.
  const UserException(
    this.message, {
    this.code,
    this.reason,
  });

  /// Returns a new [UserException], copied from the current one, but adding the given [reason].
  /// Note the added [reason] won't replace the original reason, but will be added to it.
  UserException addReason(String? reason) {
    //
    if (reason == null)
      return this;
    else {
      if (_ifHasMsgOrCode()) {
        return UserException(message, code: code, reason: joinCauses(this.reason, reason));
      } else if (this.reason != null && this.reason!.isNotEmpty)
        return UserException(this.reason, reason: reason);
      else
        return UserException(reason);
    }
  }

  /// Returns a new [UserException], by merging the current one with the given [userException].
  /// This simply means the given [userException] will be used as part of the [reason] of the
  /// current one.
  UserException mergedWith(UserException? userException) {
    //
    if (userException == null)
      return this;
    else {
      var newReason = joinCauses(userException._msgOrCode(), userException.reason);
      return addReason(newReason);
    }
  }

  /// Based on the [message], [code] and [reason], returns the title and content to be
  /// used in some UI to show the exception the user. The UI is usually a dialog or toast.
  ///
  /// If the exception has both a [message] an a [reason], the title will be
  /// the [message], and its content will be the [reason]. Otherwise, the title
  /// will be empty, and the content will be the [message].
  ///
  /// Alternatively, if you provide a numeric [code] instead of a [message], the
  /// text will be the one associated with the code (see [translateCode]
  /// and [codeTranslations]) for more details.
  ///
  (String, String) titleAndContent() {
    if (_ifHasMsgOrCode()) {
      if (reason == null || reason!.isEmpty)
        return ('', _msgOrCode());
      else
        return (_msgOrCode(), reason ?? '');
    }
    //
    else if (reason != null && reason!.isNotEmpty)
      return ('', reason ?? '');
    //
    else
      return ('User Error', '');
  }

  /// Use this to set the locale used by method [titleAndContent] to translate the
  /// text "Reason:" used to explain the chain of reasons in the [UserException].
  ///
  /// If you remove the locale with `setDefaultLocale(null)`, the default will
  /// be English of the Unites States.
  ///
  /// Note: This uses the `i18n_extension_core` package from https://pub.dev/packages/i18n_extension_core
  ///
  /// IMPORTANT: If you already use `i18n_extension_core` (in your Dart-only code)
  /// or `i18n_extension` (in your Flutter app), there is no need to ever
  /// call [UserException.setLocale], because the locale will already have been set.
  ///
  static void setLocale(String? localeStr) => DefaultLocale.set(localeStr);

  /// Joins the given strings, such as the second is the reason for the first.
  /// Will return a message such as "first\n\nReason: second".
  /// You can change this variable to inject another way to join them.
  static var joinCauses = (
    String? first,
    String? second,
  ) {
    if (first == null || first.isEmpty) return second ?? "";
    if (second == null || second.isEmpty) return first;
    return "$first${defaultJoinString()}$second";
  };

  /// The default text to join the reasons in a string.
  /// You can change this variable to inject another way to join them.
  static var defaultJoinString = () => "\n\n${"Reason:".i18n} ";

  /// If you use error [code]s, you may provide their respective text messages here,
  /// by providing a `Translations` object from the `i18n_extension` package. You can
  /// only provide messages in English, or in multiple other languages.
  ///
  /// If you are NOT using the `i18n_extension`, you can ignore [codeTranslations]
  /// and instead just modify the [translateCode] method to return a string from the [code].
  ///
  /// Example with English only:
  ///
  /// ```dart
  /// UserException.codeTranslations = Translations.byId<int>('en', {
  ///    1: { 'en': 'Invalid email' },
  ///    2: { 'en': 'There is no connection' },
  /// });
  /// ```
  ///
  /// Example with multiple languages:
  ///
  /// ```dart
  /// UserException.codeTranslations = Translations.byId<int>('en', {
  ///    1: { 'en': 'Invalid email', 'pt': 'Email inválido' },
  ///    2: { 'en': 'There is no connection', 'pt': 'Não há conexão' },
  /// });
  /// ```
  static Translations? codeTranslations;

  /// The [translateCode] method is called to convert error [code]s into text messages.
  /// If you are using use the `i18n_extension`, you may provide [codeTranslations].
  /// If you are NOT using the `i18n_extension`, you can instead modify
  /// the [translateCode] method to return a string from the [code] in any way you want.
  ///
  static String Function(int?) translateCode = (int? code) =>
      (codeTranslations == null) ? (code?.toString() ?? '') : localize(code, codeTranslations!);

  /// If there is a [code], and this [code] has a translation, return the translation.
  /// If the translation is empty, return the [message].
  /// If the is no [code], return the [message].
  /// Otherwise, return an empty text.
  String _msgOrCode() {
    var code = this.code;
    if (code != null) {
      String codeAsText = translateCode(code);
      return codeAsText.isNotEmpty ? codeAsText : (message ?? '');
    } else
      return message ?? '';
  }

  bool _ifHasMsgOrCode() => (message != null && message!.isNotEmpty) || code != null;

  @override
  String toString() => 'UserException{' + joinCauses(_msgOrCode(), reason) + '}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          reason == other.reason &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ reason.hashCode ^ code.hashCode;
}
