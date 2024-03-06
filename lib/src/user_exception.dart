// Developed by Marcelo Glasberg (2024) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/async_redux_core

import 'package:async_redux_core/src/user_exception_i18n.dart';
import 'package:i18n_extension_core/i18n_extension_core.dart';

import 'exception_code.dart';

/// The [UserException] represents an error the user could fix, like wrong typed
/// text, or missing internet connection.
///
/// Async Redux will capture [UserException]s to show them in dialogs
/// created with `UserExceptionDialog` or other UI you define in your widget
/// tree (see the explanation in the docs).
///
/// An [UserException] may have a [message] or an error [code] (if you provide
/// both, the message will be ignored), as well as an optional [cause], which
/// is a more specific root cause of the exception. For example:
///
/// ```dart
/// throw UserException('Invalid email', cause: 'Must have at least 5 characters.');
/// ```
///
/// Method [titleAndContent] returns the title and content used in the error dialog.
/// If the exception has both a [message] an a [cause], the title will be
/// the [message], and its content will be the [cause]. Otherwise, the title
/// will be empty, and the content will be the [message].
///
/// Alternatively, if you provide a [code] instead of a [message], this code must
/// be a subclass of type [ExceptionCode] that you define. In this case, the
/// message of the exception will be the string returned by
/// the [ExceptionCode.asText] method.
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
class UserException implements Exception {
  /// Some message shown to the user.
  final String? message;

  /// Another message which is the cause of the user-exception.
  final String? cause;

  /// Instead of [message] we may provide a code. This may be used for error
  /// message translations, and also to simplify receiving errors from
  /// web-services, cloud-functions etc.
  final ExceptionCode? code;

  /// Creates a [UserException], given a message [message] of type String,
  /// a [cause] of type String or [UserException], and an optional [code] of
  /// type [ExceptionCode]. All fields are optional, but usually at least
  /// the [message] or [code] is provided.
  const UserException(
    this.message, {
    this.code,
    this.cause,
  });

  /// Creates a [UserException], adding the given [cause].
  /// Note the added [cause] won't replace the original cause, but will be added to it.
  ///
  /// The added [cause] must be:
  /// - A [UserException]
  /// - A [String]
  /// - Or Null.
  UserException addCause(Object? cause) {
    //
    if (cause is String) {
      if (_ifHasMsgOrCode()) {
        return UserException(message, code: code, cause: joinCauses(this.cause, cause));
      }
      //
      else if (this.cause != null && this.cause!.isNotEmpty)
        return UserException(this.cause, cause: cause);
      //
      else
        return UserException(cause);
    }
    //
    if (cause is UserException) {
      cause = joinCauses(cause._msgOrCode(), cause.cause);
      return addCause(cause);
    }
    //
    else
      return this;
  }

  /// Based on the [message], [code] and [cause], returns the title and content to be
  /// used in some UI to show the exception the user. The UI is usually a dialog or toast.
  ///
  /// If the exception has both a [message] an a [cause], the title will be
  /// the [message], and its content will be the [cause]. Otherwise, the title
  /// will be empty, and the content will be the [message].
  ///
  /// Alternatively, if you provide a [code] instead of a [message], this code must
  /// be a subclass of type [ExceptionCode] that you define. In this case, the
  /// message of the exception will be the string returned by the [ExceptionCode.asText] method.
  ///
  (String, String) titleAndContent() {
    if (_ifHasMsgOrCode()) {
      if (cause == null || cause!.isEmpty)
        return ('', _msgOrCode());
      else
        return (_msgOrCode(), cause ?? '');
    }
    //
    else if (cause != null && cause!.isNotEmpty)
      return ('', cause ?? '');
    //
    else
      return ('User Error', '');
  }

  /// Use this to set the locale used by method [titleAndContent] to translate the
  /// text "Reason:" used to explain the chain of causes in the [UserException].
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

  /// The default text to join the causes in a string.
  /// You can change this variable to inject another way to join them.
  static var defaultJoinString = () => "\n\n${"Reason:".i18n} ";

  /// If there is a [code], and this [code] has a non-empty text returned by
  /// [ExceptionCode.asText] in the given [StringLocale], return this text.
  /// Otherwise, if the [message] is a non-empty text, return this [message].
  /// Otherwise, if there is a [code], return the [code] itself.
  /// Otherwise, return an empty text.
  String _msgOrCode() {
    String? codeAsText = code?.asText();
    if (codeAsText != null && codeAsText.isNotEmpty) return codeAsText;
    if (message != null && message!.isNotEmpty) return message!;
    return code?.toString() ?? "";
  }

  bool _ifHasMsgOrCode() => (message != null && message!.isNotEmpty) || code != null;

  @override
  String toString() => 'UserException{' + joinCauses(_msgOrCode(), cause) + '}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          cause == other.cause &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ cause.hashCode ^ code.hashCode;
}
