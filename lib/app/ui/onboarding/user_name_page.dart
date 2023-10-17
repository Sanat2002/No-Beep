import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../widgets/no_beep_title.dart';
import 'controller/onboarding_controller.dart';
import 'date_selection_onboarding.dart';

class OnboardingUserNamePage extends StatelessWidget {
  const OnboardingUserNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeController = Get.put(OnboardingController());
    final FocusNode focusNode = FocusNode();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.dark, //<-- For iOS SEE HERE (dark icons)
        ),
        title: NoBeepTitle(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).dialogBackgroundColor,
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Lottie.asset('assets/blue-waves-animations.json',
                        reverse: true),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Your Firstname?",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 12, top: 4),
                      child: storeController.hide.value
                          ? SizedBox()
                          : Text(
                              "What should we call you?",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 12, top: 12),
                      child: TextField(
                        controller:
                            storeController.userNickNameEditingController,
                        keyboardType: TextInputType.name,
                        maxLength: 10,
                        maxLines: 1,
                        autofocus: true,
                        focusNode: focusNode,
                        style:
                            Theme.of(context).inputDecorationTheme.labelStyle,
                        decoration: InputDecoration(
                            hintText: 'Eren?',
                            counterStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle
                                ?.copyWith(fontSize: 12),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: BouncingWidget(
                    onPressed: () {
                      if (storeController
                          .userNickNameEditingController.value.text
                          .trim()
                          .isEmpty) {
                        focusNode.requestFocus();
                      } else {
                        Get.to(OnboardingDateSelectionPage());
                      }
                    },
                    duration: Duration(milliseconds: 50),
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              storeController
                                      .userNickNameEditingController.value.text
                                      .trim()
                                      .isNotEmpty
                                  ? storeController
                                      .userNickNameEditingController.value.text
                                      .trim()
                                  : "Add Name",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context).backgroundColor),
                            ),
                            Visibility(
                              visible: storeController
                                  .userNickNameEditingController.value.text
                                  .trim()
                                  .isNotEmpty,
                              child: SizedBox(
                                width: 20,
                              ),
                            ),
                            Visibility(
                              visible: storeController
                                  .userNickNameEditingController.value.text
                                  .trim()
                                  .isNotEmpty,
                              child: Icon(
                                Icons.arrow_right_alt,
                                color: Theme.of(context).backgroundColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
