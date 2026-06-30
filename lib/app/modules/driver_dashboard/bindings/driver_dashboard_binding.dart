import 'package:get/get.dart';
import '../controllers/driver_dashboard_controller.dart';
import '../controllers/driver_jobs_controller.dart';

class DriverDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverDashboardController>(
      () => DriverDashboardController(),
    );
    Get.lazyPut<DriverJobsController>(
      () => DriverJobsController(),
    );
  }
}
