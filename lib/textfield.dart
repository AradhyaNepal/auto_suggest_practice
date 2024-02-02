import 'package:auto_suggest/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutocompleteBasicExample extends StatefulWidget {
  const AutocompleteBasicExample({super.key});

  @override
  State<AutocompleteBasicExample> createState() =>
      _AutocompleteBasicExampleState();
}

class _AutocompleteBasicExampleState extends State<AutocompleteBasicExample> {
  final _suggestionOpenedController = ValueNotifier(false);

  @override
  void dispose() {
    _suggestionOpenedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _suggestionOpenedController.value) {
              // debugger();
              _suggestionOpenedController.value=focusNode.hasFocus;
              // debugger();
            }
          });
          return ValueListenableBuilder(
            valueListenable: _suggestionOpenedController,
            builder: (context,value,child){
              return Container(
                decoration: _suggestionOpenedController.value
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
                child:child??const SizedBox(),
              );
            },
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onFieldSubmitted: (_)=>onFieldSubmitted(),
            ),
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          return kCountries
              .where((element) => element.contains(textEditingValue.text));
        },
        onSelected: (String selection) {
          _suggestionOpenedController.value = false;
        },
      ),
    );
  }
}
