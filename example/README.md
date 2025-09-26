# 示例（example）

此目录提供最小可运行示例，演示如何在 ArkUI 组件中使用 `tw()`：

```ets
import { tw } from '@ymhc/tailwind'

@Component
export struct DemoSnippet {
  build() {
    Text('Hello')
      .attributeModifier(tw('text-xl font-bold text-blue-600'))
  }
}
```

完整能力、映射规则与安装步骤请参见项目根 README。
