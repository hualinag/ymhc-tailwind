import { tw } from '../src/main/ets/components/base/style/TailwindAttributeModifier.ets'

@Entry
@Component
export struct DemoPage {
  build() {
    Column() {
      Text('Tailwind Demo')
        .attributeModifier(tw('text-2xl font-bold text-blue-600'))
      Text('说明：本示例展示 AttributeModifier + tw 的基本用法')
        .attributeModifier(tw('text-sm text-gray-600 mt-2'))
    }
    .attributeModifier(tw('p-4 bg-white rounded-lg shadow-md w-full h-[200vp] justify-center items-center'))
  }
}
