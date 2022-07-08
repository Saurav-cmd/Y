import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:y/utility/colors.dart';

import '../../controllers/category_controller.dart';

class BottomSheetDesign extends StatefulWidget {
  const BottomSheetDesign({Key? key}) : super(key: key);

  @override
  State<BottomSheetDesign> createState() => _BottomSheetDesignState();
}

class _BottomSheetDesignState extends State<BottomSheetDesign> {
  CategoryController cC = Get.put(CategoryController());

  fetchCategoryFormApi() async {
    await cC.fetchCategoriesList(context).whenComplete(() {
      cC.category!.category;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategoryFormApi();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.020),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() {
            if (cC.isLoading.value) {
              return const LinearProgressIndicator();
            } else {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cC.category!.category!.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, [
                              cC.category!.category![i].name,
                              cC.category!.category![i].id,
                            ]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${cC.category!.category![i].name}",
                                    style: TextStyle(
                                        color: ChooseColor(0).blueColor,
                                        fontSize: size.height * 0.014 +
                                            size.width * 0.014),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          })
        ],
      ),
    );
  }
}
