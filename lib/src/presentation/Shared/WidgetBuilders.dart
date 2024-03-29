import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../config/utils/styles/app_colors.dart';
import '../../data/local/localData_cubit/local_data_cubit.dart';
import '../../data/remote/RemoteData_cubit/RemoteData_cubit.dart';
import 'Components.dart';

///Widget List Builder
Widget itemsList({
  String? name,
  String? img,
}) {
  bool isClicked = false;
  return GestureDetector(
    child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white38,
          border: Border.all(
              color: isClicked == false
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.3),
              style: BorderStyle.solid,
              width: 0.75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                img!,
                fit: BoxFit.contain,
                scale: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name!,
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )),
  );
}

///Row Widget List Builder
Widget rowHomeItems({
  required String name,
  required String img,
  required Function onTap,
}) {
  return InkWell(
    onTap: () {
      onTap(name);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white70,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 100,
                  width: 150,
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          return loadingProgress != null
                              ? Center(
                                  child: LoadingAnimationWidget.flickr(
                                      leftDotColor: Colors.blue,
                                      rightDotColor: Colors.yellow,
                                      size: 30))
                              : child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(name),
            ],
          ),
        ),
      ),
    ),
  );
}

///Social Media List Builder
Widget socialMediaItem({
  required int index,
  required String img,
  required Function onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: InkWell(
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            img,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              return loadingProgress != null
                  ? Center(
                      child: LoadingAnimationWidget.flickr(
                          leftDotColor: Colors.blue,
                          rightDotColor: Colors.yellow,
                          size: 30))
                  : child;
            },
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
}

Widget loadButton({
  double? buttonHeight,
  double? buttonWidth,
  Color? textColor,
  double? textSize,
  double? buttonElevation,
  required Function() onPressed,
  required String buttonText,
}) {
  return BlocBuilder<RemoteDataCubit, RemoteAppStates>(
      builder: (context, state) {
    if (state is GettingData) {
      return loadingAnimation(
          loadingType: LoadingAnimationWidget.beat(
              color: AppColors.primaryColor, size: getWidth(10, context)));
    } else {
      return Container(
        width: buttonWidth ?? getWidth(80, context),
        height: buttonHeight ?? 60.0,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FilledButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: buttonElevation ?? 0.0,
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: textSize ?? getWidth(10, context),
                color: textColor ?? Colors.white),
          ),
        ),
      );
    }
  });
}

///For photo preview
Widget previewImage(
    {double padding = 5.0,
    Color backgroundColor = Colors.transparent,
    double photoRadius = 15.0,
    required fileUser,
    bool editable = false,
    VoidCallback? onTap,
    required context}) {
  fileUser = base64Decode(fileUser);

  return InkWell(
    splashColor: Colors.transparent,
    onTap: onTap ?? () {},
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(photoRadius),
                child: Image.memory(
                  fileUser,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: editable,
          replacement: Container(),
          child: Positioned(
            bottom: 7,
            right: 7,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black12),
              child: const Icon(
                Icons.mode_edit_outline_outlined,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget getSkeletonLoading() {
  return Builder(
    builder: (context) {
      final stateLocalData = context.watch<LocalDataCubit>().state;
      final stateRemoteData = context.watch<RemoteDataCubit>().state;
      if (stateLocalData is GettingLocalData ||
          stateRemoteData is GettingData) {
        return Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 50,
            children: List.generate(10, (index) {
              return Container(
                height: getHeight(20, context),
                width: getWidth(90, context),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
              );
            }));
      } else {
        return Container();
      }
    },
  );
}
