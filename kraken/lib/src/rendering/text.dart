/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

import 'package:flutter/rendering.dart';
import 'package:kraken/style.dart';
import 'package:kraken/element.dart';

class TextParentData extends ContainerBoxParentData<RenderBox> {
}

class RenderTextBox extends RenderBox
  with
    ElementStyleMixin,
    TextStyleMixin,
    DimensionMixin,
    ContainerRenderObjectMixin<RenderBox, TextParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, TextParentData> {

  RenderTextBox({
    this.targetId,
    String text,
    StyleDeclaration style,
  }) : assert(text != null) {
    _text = text;
    _style = style;

    TextOverflow overflow = _isTextOverflowEllipsis() ?
        TextOverflow.ellipsis : TextOverflow.clip;

    _renderParagraph = RenderParagraph(
      createTextSpanWithStyle(text, style),
      textAlign: getTextAlignFromStyle(style),
      textDirection: TextDirection.ltr,
      overflow: overflow,
    );
    add(_renderParagraph);
  }

  void _rebuild() {
    _renderParagraph.text = createTextSpanWithStyle(text, style);
    _renderParagraph.textAlign = getTextAlignFromStyle(style);
    _renderParagraph.markNeedsLayout();
  }

  RenderParagraph _renderParagraph;
  int targetId;
  String _text;
  String get text => _text;
  set text(String newText) {
    _text = newText;
    _rebuild();
  }

  StyleDeclaration _style;
  StyleDeclaration get style => _style;
  set style(StyleDeclaration newStyle) {
    _style = newStyle;
    _rebuild();
  }

  bool _isTextOverflowEllipsis() {
    String overflowX = style['overflowX'] != '' ?
      style['overflowX'] : style['overflow'];

    return overflowX != 'visible' &&
      style['whiteSpace'] == 'nowrap' &&
      style['textOverflow'] == 'ellipsis';
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TextParentData) {
      child.parentData = TextParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox child = firstChild;

    // @TODO when in flex-grow or flex-shrink width needs to be recalculated
    Node currentNode = getEventTargetByTargetId<Node>(targetId);
    Element parentNode = currentNode.parentNode;
    double elementWidth = getElementWidth(parentNode.targetId);
    if (child != null) {
      BoxConstraints additionalConstraints = constraints;

      if (_isTextOverflowEllipsis() ||
          (style['whiteSpace'] != 'nowrap' && elementWidth != null)
      ) {
        additionalConstraints = BoxConstraints(
          minWidth: 0,
          maxWidth: elementWidth,
          minHeight: 0,
          maxHeight: double.infinity,
        );
      }
      child.layout(additionalConstraints, parentUsesSize: true);
      size = child.size;
    } else {
      performResize();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    if (child != null) {
      context.paintChild(child, offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

