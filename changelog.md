# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic Versioning.

## [1.0.1] - 2025-09-26
### Added
- 新增示例目录 `example/` 与 `DemoPage.ets`，并在主 `README.md` 增加示例链接，便于开发者快速上手。

## [1.0.0] - 2025-09-26
### Added
- 初始发布：ArkUI Tailwind AttributeModifier 能力（`.attributeModifier(tw('...'))`）。
- 覆盖 spacing/sizing/colors/typography/flex/border/shadow/opacity/line-height 等核心映射。
- 强类型实现：无 any/unknown，对象均有显式接口/类定义。
- 文档：Tailwind ↔ ArkUI 映射规则、用法示例与约束说明。

### Security
- 发布产物过滤与 LICENSE（MIT）合规。
