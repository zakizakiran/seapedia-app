import 'package:get/get.dart';
import '../controllers/admin_jobs_controller.dart';

class AdminJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminJobsController>(() => AdminJobsController());
  }
}
