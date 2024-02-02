

import 'package:auto_suggest/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({super.key});

  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  //  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final DynamicFieldController dynamicFieldController =
    Get.put(DynamicFieldController());

    return LayoutBuilder(
        builder: (context, constraints) => Autocomplete<String>(
          // focusNode: focusNode,
          // textEditingController: textEditingController,
            optionsViewBuilder: (context, onSelected, options) {
              // debugger();
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.r,
                              offset: Offset(0, 4.h),
                              color: const Color(0x10000000),
                            )
                          ],
                          color: Colors.white,
                        ),
                        // height: 52.0 * options.length,
                        width: constraints.biggest.width,
                        child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: options.map((opt) {
                                return GestureDetector(
                                    onTap: () {
                                      onSelected(opt);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(6.h),
                                      child: Text(
                                        opt,
                                        // style: generalMontserratTextStyle(16)
                                        //     .copyWith(fontWeight: FontWeight.w500),
                                      ),
                                    ));
                              }).toList(),
                            )))),
              );
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              // debugger();

              focusNode.addListener(() {
                if (focusNode.hasFocus !=
                    dynamicFieldController.isSuggestionBoxOpen.value) {
                  // debugger();
                  dynamicFieldController.isSuggestionBoxOpen(focusNode.hasFocus);
                  // debugger();
                }
              });
              return Obx(
                    () {
                  return Container(
                    decoration: dynamicFieldController.isSuggestionBoxOpen.value
                        ? BoxDecoration(
                      color: Colors.white,
                      border: const Border(bottom: BorderSide.none),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.r,
                          offset: Offset(0, 4.h),
                          color: const Color(0x10000000),
                        )
                      ],
                    )
                        : null,
                    child: TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (_)=>onFieldSubmitted(),
                    ),
                  );
                },
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              // if (textEditingValue.text == '') {
              //   return const Iterable<String>.empty();
              // }
              // return _kOptions.where((String option) {
              //   return option.contains(textEditingValue.text.toLowerCase());
              // });

              return _kOptions;
            },
            onSelected: (String selection) {
              dynamicFieldController.isSuggestionBoxOpen(false);
              debugPrint('You just selected $selection');
            },
            ),
        );
    }
}