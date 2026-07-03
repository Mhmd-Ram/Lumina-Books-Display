import '../../core/localization/app_strings.dart';
import 'services/auth_service.dart';

/// Bridges an [AuthErrorType] (data layer) to a localized, user-facing message.
/// Lives in the feature layer so the service never imports UI strings.
extension AuthErrorL10n on AuthErrorType {
  String message(AppStrings s) => switch (this) {
    AuthErrorType.wrongCredentials => s.errWrongCredentials,
    AuthErrorType.emailInUse => s.errEmailInUse,
    AuthErrorType.weakPassword => s.errWeakPassword,
    AuthErrorType.invalidEmail => s.invalidEmail,
    AuthErrorType.network => s.errNetwork,
    AuthErrorType.tooManyRequests => s.errTooManyRequests,
    AuthErrorType.userDisabled => s.errUserDisabled,
    AuthErrorType.unknown => s.errGeneric,
  };
}
