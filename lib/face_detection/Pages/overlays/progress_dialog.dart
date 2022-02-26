import 'package:get/get.dart';

import '../common/build_circular_loading.dart';

void isLoading(bool status) {
  status
      ? Get.dialog(
          const BuildCircularLoading(),
          barrierDismissible: false,
        )
      : Get.back();
}
