import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:playground/component/component.dart';
import 'package:playground/widget/add_component.dart';

enum ImageType {
  png,
  jpg,
  svg,
  json,
}

class CCImage extends Component {
  double? width;
  double? height;
  String? url;
  BoxFit? fit;
  ImageType? imageType;
  CCImage({
    required String name,
    required Function(Component?) onUpdate,
    required Function(Component) onDelete,
    Function(Component)? onWrap,
    Function(Component)? onWrapChildren,
  }) {
    super.name = name;
    super.onUpdate = onUpdate;
    super.onDelete = onDelete;
    super.onWrap = onWrap;
    super.onWrapChildren = onWrapChildren;
  }

  @override
  Component copyWith({
    String? name,
    Function(Component?)? onUpdate,
    Function(Component)? onDelete,
    Function(Component)? onWrap,
    Function(Component)? onWrapChildren,
    double? width,
    double? height,
    String? url,
    BoxFit? fit,
    ImageType? imageType,
  }) {
    var component = CCImage(
      name: name ?? this.name!,
      onUpdate: onUpdate ?? this.onUpdate!,
      onDelete: onDelete ?? this.onDelete!,
      onWrap: onWrap ?? this.onWrap,
      onWrapChildren: onWrapChildren ?? this.onWrapChildren,
    );
    component.width = width ?? this.width;
    component.height = height ?? this.height;
    component.url = url ?? this.url;
    component.fit = fit ?? this.fit;
    component.imageType = imageType ?? this.imageType;
    return component;
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  Widget toWidgetViewer(BuildContext context) {
    // TODO: implement toWidget
    throw UnimplementedError();
  }

  @override
  Widget toWidgetProperties(BuildContext context) {
    // TODO: implement toWidget
    return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
      return GestureDetector(
        onTap: () {
          isExpand.value = !isExpand.value;
        },
        child: Obx(() {
          if (!isExpand.value) {
            return Container(
              margin: const EdgeInsets.only(left: 10),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Image $name ${child != null ? "..." : ""}"),
                      IconButton(
                          onPressed: () {
                            onDelete?.call(this);
                          },
                          icon: Icon(Icons.close, size: 20))
                    ],
                  ),
                  SizedBox(width: 5),
                  child?.toWidgetProperties(context) ?? const SizedBox()
                ],
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Image $name"),
                SizedBox(
                  height: 5,
                ),

                ///control
                Row(
                  children: [
                    Flexible(
                      child: AddComponent(
                        text: "Wrap by Component",
                        onPressed: (BuildContext context) async {
                          /// add parent
                          Component.addComponent(
                            context: context,
                            childCount: 0,
                            onUpdate: (Component? parent) {
                              if (parent != null) {
                                parent.child = this;
                                onWrap?.call(parent);
                              }
                              innerSetState.call(() {});
                            },
                            onDelete: onDelete!,
                            onWrap: onWrap!,
                            onWrapChildren: onWrapChildren!,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: AddComponent(
                        text: "Wrap by Children Component",
                        onPressed: (BuildContext context) async {
                          /// add parent
                          Component.addComponent(
                            context: context,
                            childCount: 0,
                            onUpdate: (Component? parent) {
                              if (parent != null) {
                                parent.children.add(this);
                                onWrapChildren?.call(parent);
                              }
                              innerSetState.call(() {});
                            },
                            onDelete: onDelete!,
                            onWrap: onWrap!,
                            onWrapChildren: onWrapChildren!,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          /// add child
                          onDelete?.call(this);
                        },
                        child: Text('Remove'),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.text,
                    initialValue: name,
                    onChanged: (value) {
                      name = value;
                      onUpdate?.call(null);
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Url'),
                    keyboardType: TextInputType.text,
                    initialValue: url,
                    onChanged: (value) {
                      url = url;
                      onUpdate?.call(null);
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Width'),
                          keyboardType: TextInputType.number,
                          initialValue: width != null ? "$width" : null,
                          onChanged: (value) {
                            width = double.parse(value);
                            onUpdate?.call(null);
                          },
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Height'),
                          keyboardType: TextInputType.number,
                          initialValue: height != null ? "$height" : null,
                          onChanged: (value) {
                            height = double.parse(value);
                            onUpdate?.call(null);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// box fit
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.centerLeft,
                  child: Builder(builder: (c) {
                    return TextFormField(
                        key: UniqueKey(),
                        decoration: InputDecoration(labelText: 'Fit'),
                        keyboardType: TextInputType.text,
                        initialValue: fit != null ? "$fit" : null,
                        onChanged: (value) {
                          onUpdate?.call(null);
                        },
                        onTap: () {
                          ///
                          Component.selectBoxFit(
                            context: c,
                            callBack: (BoxFit? boxFit) {
                              innerSetState.call(() {
                                fit = boxFit;
                              });
                              onUpdate?.call(null);
                            },
                          );
                        });
                  }),
                ),

                /// box type
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.centerLeft,
                  child: Builder(builder: (c) {
                    return TextFormField(
                        key: UniqueKey(),
                        decoration: InputDecoration(labelText: 'Image Type'),
                        keyboardType: TextInputType.text,
                        initialValue: fit != null ? "$fit" : null,
                        onChanged: (value) {
                          onUpdate?.call(null);
                        },
                        onTap: () {
                          ///
                          Component.selectImageType(
                            context: c,
                            callBack: (ImageType? type) {
                              innerSetState.call(() {
                                imageType = type;
                              });
                              onUpdate?.call(null);
                            },
                          );
                        });
                  }),
                ),

                SizedBox(height: 5),
                child?.toWidgetProperties(context) ?? const SizedBox()
              ],
            ),
          );
        }),
      );
    });
  }
}
