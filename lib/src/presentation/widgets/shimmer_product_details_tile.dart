import 'package:flutter/material.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';

class ShimmerProductDetailsTile extends StatelessWidget {
  final int count;
  const ShimmerProductDetailsTile({super.key, this.count = 10});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemCount: count,
      itemBuilder: (context, index) => buildShimmerContainer(context),
    );
  }

  Widget buildShimmerContainer(context) {
    return Shimmer.fromColors(
      baseColor:Theme.of(context).cardColor,
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.kGray
          : Colors.grey.shade300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.kLightGray2,
                ),
              ),
              verticalSpaceRegular,
              Container(
                height: 15,
                decoration: BoxDecoration(
                  color: AppColors.kLightGray2,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              verticalSpaceMedium,
              // Container(
              //   height: 15,
              //   decoration: BoxDecoration(
              //     color: AppColors.kLightGray2,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildProductsCategoryShimmer extends StatelessWidget {
  const BuildProductsCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: buildCategoryButtonShimmer()),
          horizontalSpaceRegular,
          Flexible(child: buildCategoryButtonShimmer()),
          horizontalSpaceRegular,
          Flexible(child: buildCategoryButtonShimmer()),
          horizontalSpaceRegular,
          Flexible(child: buildCategoryButtonShimmer()),
        ],
      ),
    );
  }

  Widget buildCategoryButtonShimmer() {
    return SizedBox(
      height: 20,
      width: 100,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class ShimmerProductsCard extends StatelessWidget {
  const ShimmerProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return buildProductCardShimmer();
        });
  }

  Widget buildProductCardShimmer() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
