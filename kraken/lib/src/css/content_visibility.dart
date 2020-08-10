/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */
import 'package:flutter/rendering.dart';
import 'package:kraken/css.dart';
import 'package:kraken/element.dart';
import 'package:kraken/rendering.dart';

// CSS Content Visibility: https://www.w3.org/TR/css-contain-2/#content-visibility

mixin CSSContentVisibilityMixin on Node {
  RenderVisibility renderVisibility;
  bool _hasIntersectionObserver = false;

  void setContentVisibilityIntersectionObserver(
      RenderIntersectionObserver renderIntersectionObserver, String contentVisibility) {
    if (contentVisibility == AUTO && !_hasIntersectionObserver) {
      renderIntersectionObserver.addListener(_handleIntersectionChange);
      // Call needs paint make sure intersection observer works immediately
      renderIntersectionObserver.markNeedsPaint();
      _hasIntersectionObserver = true;
    }
  }

  void _handleIntersectionChange(IntersectionObserverEntry entry) {
    renderVisibility.hidden = !entry.isIntersecting;
  }

  void updateRenderContentVisibility(String contentVisibility,
      {RenderObjectWithChildMixin parentRenderObject, RenderIntersectionObserver renderIntersectionObserver}) {
    if (renderVisibility != null) {
      renderVisibility.hidden = (contentVisibility == HIDDEN || contentVisibility == AUTO);
      if (contentVisibility != AUTO && _hasIntersectionObserver) {
        renderIntersectionObserver.removeListener(_handleIntersectionChange);
        _hasIntersectionObserver = false;
      }
    } else if (contentVisibility == HIDDEN || contentVisibility == AUTO) {
      RenderObject child = parentRenderObject.child;
      // Drop child by set null first.
      parentRenderObject.child = null;
      renderVisibility = RenderVisibility(hidden: true, maintainSize: false, child: child);
      parentRenderObject.child = renderVisibility;
    }

    setContentVisibilityIntersectionObserver(renderIntersectionObserver, contentVisibility);
  }
}
