import { tw } from '.'

@Entry
@Component
struct MainPage {
  build() {
    Column({ space: 20 }) {
      // 在原生组件上直接挂修饰器，不使用包装组件
      Column() {
        Text('直接修饰器：蓝色加粗标题')
          .attributeModifier(tw('text-4xl font-bold text-blue-300'))
        Text('灰色说明文本')
          .attributeModifier(tw('text-sm text-gray-600'))
      }
      .attributeModifier(tw('bg-white rounded-lg shadow-md p-4'))
      .attributeModifier(tw('w-full'))
    }
    .padding(20)
  }
}