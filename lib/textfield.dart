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
  final _globalKey = GlobalKey();

  @override
  void dispose() {
    _suggestionOpenedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<String>(
        optionsViewBuilder: (context, onSelected, options) {
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
                width: constraints.biggest.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: options.map(
                      (opt) {
                        return InkWell(
                            //Todo: DO NOT USE GESTURE DETECTOR HERE, BAD TOUCHING EXPERIENCE TO THE USER.
                            //Todo: i.e USER IS ONLY ALLOWED TO CLICK THE TEXT WITH PRECISION, NOT THE RIGHT EMPTY SPACE
                            splashColor: Colors.transparent,
                            onTap: () {
                              onSelected(opt);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(6.h),
                              child: Text(
                                opt,
                                // style: generalMontserratTextStyle(16) //TODO: IMPLEMENT IT
                                //     .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ));
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          );
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          return ValueListenableBuilder(
            valueListenable: _suggestionOpenedController,
            builder: (context, value, child) {
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
                child: child ?? const SizedBox(),
              );
            },
            child: Focus(
              //Just better way to Listen, in addListener we need to remove Listener too, else it might cause memory leaks
              onFocusChange: (hasFocus) {
                //No need to check whether the value changed
                //Value notifier is smart enough to do it auto
                _suggestionOpenedController.value = focusNode.hasFocus;
              },
              child: TextFormField(
                key: _globalKey,
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (_) => onFieldSubmitted(),
              ),
            ),
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          final output = kCountries.where((element) => element
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
          //No need to check whether the value changed
          //Value notifier is smart enough to do it auto
          _suggestionOpenedController.value = output
              .isNotEmpty; //TODO: VERIFY WHETHER THIS EXTRA FEATURE IS HELPFUL, i.e ON NO ITEM, DECORATION GETS REMOVED
          return output;
        },
        onSelected: (String selection) {
          // If you decided to not UnFocus on selected,
          // then you should remove code below it too.
          // ELSE UI mismatch
          // On item selected background changes, but when you clear item and re-search:
          // the dropdown items will show but the background will not change. <-Bug
          // FocusScope.of(context).unfocus();
          // _suggestionOpenedController.value = false;
        },
      ),
    );
  }
}
