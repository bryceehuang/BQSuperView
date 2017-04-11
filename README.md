# BQSuperView
凌驾所有视图之上的SuperView.

开发中可能会遇到这样的问题：使一个View在屏幕中不被任何视图遮盖？
BQSuperView就是这样一个View, 视图是单独添加到一个UIWindow中，就算是alert view 或者 键盘都遮盖不了。

## 效果图
![superview](superview.gif)


## 使用
1. 将BQSuperView文件导入项目。
2. 显示：创建BQSuperView， 调用show 
3. 隐藏：调用superView 的hide方法隐藏。
