import 'package:get/get.dart';
import '../controllers/driver_job_detail_controller.dart';

class DriverJobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverJobDetailController>(
      () => DriverJobDetailController(),
    );
  }
}
