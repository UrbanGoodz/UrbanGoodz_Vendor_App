import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:sixam_mart/features/favorite/controllers/favorite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class AddFavoriteView extends StatefulWidget {
  final Item? item;
  final double? top, right;
  final double? left;
  final int? storeId;
  final bool interceptPointers;
  const AddFavoriteView({super.key, required this.item, this.top = 15, this.right = 15, this.left, this.storeId, this.interceptPointers = false});

  @override
  State<AddFavoriteView> createState() => _AddFavoriteViewState();
}

class _AddFavoriteViewState extends State<AddFavoriteView> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top, right: widget.right, left: widget.left,
      child: GetBuilder<FavoriteController>(builder: (favoriteController) {
        bool isWished;
        if(widget.storeId != null) {
          isWished = favoriteController.wishStoreIdList.contains(widget.storeId);
        } else {
          isWished = favoriteController.wishItemIdList.contains(widget.item!.id);
        }
        Widget favoriteButton = InkWell(
          onTap: favoriteController.isRemoving ? null : () {
            if(AuthHelper.isLoggedIn()) {
              if(widget.storeId != null) {
                isWished ? favoriteController.removeFromFavoriteList(widget.storeId, true) : favoriteController.addToFavoriteList(null, widget.storeId, true);
              } else {
                isWished ? favoriteController.removeFromFavoriteList(widget.item!.id, false) : favoriteController.addToFavoriteList(widget.item, null, false);
              }
            }else {
              showCustomSnackBar('you_are_not_logged_in'.tr);
            }
            _controller.reverse().then((value) => _controller.forward());
          },
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: Icon(isWished ? CupertinoIcons.heart_solid : CupertinoIcons.heart, color: isWished ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.3), size: 25),
          ),
        );
        return PointerInterceptor(intercepting: widget.interceptPointers, child: favoriteButton);
      }),
    );
  }
}
