/*
 * Copyright (C) 2020 Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

#include "comment_node.h"

namespace kraken::binding::jsc {

void bindCommentNode(std::unique_ptr<JSContext> &context) {
  auto commentNode = JSCommentNode::instance(context.get());
  JSC_GLOBAL_SET_PROPERTY(context, "CommentNode", commentNode->classObject);
}

JSCommentNode::JSCommentNode(JSContext *context) : JSNode(context, "CommentNode") {}

std::unordered_map<JSContext *, JSCommentNode *> & JSCommentNode::getInstanceMap() {
  static std::unordered_map<JSContext *, JSCommentNode *> instanceMap;
  return instanceMap;
}

JSCommentNode *JSCommentNode::instance(JSContext *context) {
  auto instanceMap = getInstanceMap();
  if (!instanceMap.contains(context)) {
    instanceMap[context] = new JSCommentNode(context);
  }
  return instanceMap[context];
}
JSCommentNode::~JSCommentNode() {
  auto instanceMap = getInstanceMap();
  instanceMap.erase(context);
}

JSObjectRef JSCommentNode::instanceConstructor(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount,
                                               const JSValueRef *arguments, JSValueRef *exception) {
  JSStringRef commentData = nullptr;

  if (argumentCount > 0) {
    commentData = JSValueToStringCopy(ctx, arguments[0], exception);
  }

  auto textNode = new CommentNodeInstance(this, commentData);
  return textNode->object;
}

JSCommentNode::CommentNodeInstance::CommentNodeInstance(JSCommentNode *jsCommentNode, JSStringRef data)
  : NodeInstance(jsCommentNode, NodeType::COMMENT_NODE), nativeComment(new NativeComment(nativeNode)) {
  if (data != nullptr) {
    m_data.setString(data);
  }

  std::string str = m_data.string();
  auto args = buildUICommandArgs(str);

  ::foundation::UICommandTaskMessageQueue::instance(jsCommentNode->contextId)
    ->registerCommand(eventTargetId, UICommand::createComment, args, 1, nativeComment);
}

void JSCommentNode::CommentNodeInstance::setProperty(std::string &name, JSValueRef value, JSValueRef *exception) {
  NodeInstance::setProperty(name, value, exception);
  if (exception != nullptr) return;
}

JSValueRef JSCommentNode::CommentNodeInstance::getProperty(std::string &name, JSValueRef *exception) {
  auto propertyMap = getPropertyMap();

  if (!propertyMap.contains(name)) return NodeInstance::getProperty(name, exception);

  CommentProperty property = propertyMap[name];

  switch (property) {
  case CommentProperty::kData:
    return m_data.makeString();
  case CommentProperty::kNodeName: {
    JSStringRef nodeName = JSStringCreateWithUTF8CString("#comment");
    return JSValueMakeString(_hostClass->ctx, nodeName);
  }
  case CommentProperty::kLength:
    return JSValueMakeNumber(_hostClass->ctx, m_data.size());
  }
}

void JSCommentNode::CommentNodeInstance::getPropertyNames(JSPropertyNameAccumulatorRef accumulator) {
  NodeInstance::getPropertyNames(accumulator);

  for (auto &property : getCommentPropertyNames()) {
    JSPropertyNameAccumulatorAddName(accumulator, property);
  }
}

std::array<JSStringRef, 2> &JSCommentNode::CommentNodeInstance::getCommentPropertyNames() {
  static std::array<JSStringRef, 2> propertyNames{
    JSStringCreateWithUTF8CString("data"),
    JSStringCreateWithUTF8CString("length"),
  };
  return propertyNames;
}

const std::unordered_map<std::string, JSCommentNode::CommentNodeInstance::CommentProperty> &
JSCommentNode::CommentNodeInstance::getPropertyMap() {
  static std::unordered_map<std::string, CommentProperty> propertyMap{
    {"data", CommentProperty::kData},
    {"nodeName", CommentProperty::kNodeName},
    {"length", CommentProperty::kLength},
  };
  return propertyMap;
}

std::string JSCommentNode::CommentNodeInstance::internalGetTextContent() {
  return m_data.string();
}

JSCommentNode::CommentNodeInstance::~CommentNodeInstance() {
  delete nativeComment;
}

void JSCommentNode::CommentNodeInstance::internalSetTextContent(JSStringRef content, JSValueRef *exception) {
  m_data.setString(content);
}

} // namespace kraken::binding::jsc