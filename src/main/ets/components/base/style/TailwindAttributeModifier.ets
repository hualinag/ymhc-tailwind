import { TailwindStyleParser, TailwindStyles, ShadowOptions } from './TailwindStyleParser'

// 为避免 any/unknown，声明一个具备通用属性链的节点接口
export interface NodeLike {
  padding?: (value: number) => NodeLike
  margin?: (value: number) => NodeLike
  width?: (value: string | number) => NodeLike
  height?: (value: string | number) => NodeLike
  backgroundColor?: (value: string) => NodeLike
  opacity?: (value: number) => NodeLike
  borderRadius?: (value: number) => NodeLike
  shadow?: (value: ShadowOptions) => NodeLike
  border?: (options: BorderOptions) => NodeLike
  fontSize?: (value: number) => NodeLike
  fontColor?: (value: string) => NodeLike
  fontWeight?: (value: FontWeight) => NodeLike
  textAlign?: (value: TextAlign) => NodeLike
  justifyContent?: (value: FlexAlign) => NodeLike
  alignItems?: (value: HorizontalAlign) => NodeLike
}

class BorderOptions {
  width: number
  constructor(width: number) {
    this.width = width
  }
}

class TwModifier implements AttributeModifier<NodeLike> {
  private readonly styles: TailwindStyles
  constructor(className: string) {
    const parser = TailwindStyleParser.getInstance()
    this.styles = parser.parseClasses(className || '')
  }

  applyNormalAttribute(node: NodeLike): void {
    // 容器通用属性
    if (this.styles.padding !== undefined && node.padding) { node.padding(this.styles.padding) }
    if (this.styles.margin !== undefined && node.margin) { node.margin(this.styles.margin) }
    if (this.styles.width !== undefined && node.width) { node.width(this.styles.width) }
    if (this.styles.height !== undefined && node.height) { node.height(this.styles.height) }
    if (this.styles.backgroundColor && node.backgroundColor) { node.backgroundColor(this.styles.backgroundColor) }
    if (this.styles.opacity !== undefined && node.opacity) { node.opacity(this.styles.opacity) }
    if (this.styles.borderRadius !== undefined && node.borderRadius) { node.borderRadius(this.styles.borderRadius) }
    if (this.styles.shadow && node.shadow) { node.shadow(this.styles.shadow as ShadowOptions) }
    if (this.styles.borderWidth !== undefined && node.border) { node.border(new BorderOptions(this.styles.borderWidth)) }

    // 文本属性
    if (this.styles.fontSize !== undefined && node.fontSize) { node.fontSize(this.styles.fontSize) }
    if (this.styles.fontColor && node.fontColor) { node.fontColor(this.styles.fontColor) }
    if (this.styles.fontWeight !== undefined && node.fontWeight) { node.fontWeight(this.styles.fontWeight) }
    if (this.styles.textAlign !== undefined && node.textAlign) { node.textAlign(this.styles.textAlign) }
    if (this.styles.justifyContent !== undefined && node.justifyContent) { node.justifyContent(this.styles.justifyContent) }
    if (this.styles.alignItems !== undefined && node.alignItems) { node.alignItems(this.styles.alignItems) }
  }
}

// 对外提供工厂方法
export function tw(className: string): AttributeModifier<NodeLike> {
  return new TwModifier(className)
}


