import 'package:get/get.dart';
import 'package:amorra/presentation/controllers/auth/onboarding/onboarding_controller.dart';

/// Onboarding Binding
/// Dependency injection for onboarding screen
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}
