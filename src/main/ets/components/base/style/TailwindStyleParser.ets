/**
 * Tailwind样式解析器
 * 符合鸿蒙开发规范
 */
export class TailwindStyleParser {
  private static instance: TailwindStyleParser

  static getInstance(): TailwindStyleParser {
    if (!TailwindStyleParser.instance) {
      TailwindStyleParser.instance = new TailwindStyleParser()
    }
    return TailwindStyleParser.instance
  }

  /**
   * 解析Tailwind类名并返回ArkTS样式属性
   */
  parseClasses(classNames: string): TailwindStyles {
    const classes: string[] = classNames.split(' ').filter((cls: string) => cls.trim())
    const styles: TailwindStyles = {}

    classes.forEach((className: string) => {
      const trimmedClass: string = className.trim()
      if (trimmedClass) {
        this.applyClass(styles, trimmedClass)
      }
    })

    return styles
  }

  /**
   * 应用单个Tailwind类
   */
  private applyClass(styles: TailwindStyles, className: string): void {
    // 间距类
    if (className.startsWith('p-')) {
      const value: number = this.getSpacingValue(className.substring(2))
      styles.padding = value
    } else if (className.startsWith('px-')) {
      const token: string = className.substring(3)
      const value: number = this.getSpacingValue(token)
      styles.paddingLeft = value
      styles.paddingRight = value
    } else if (className.startsWith('py-')) {
      const token: string = className.substring(3)
      const value: number = this.getSpacingValue(token)
      styles.paddingTop = value
      styles.paddingBottom = value
    } else if (className.startsWith('m-')) {
      const value: number = this.getSpacingValue(className.substring(2))
      styles.margin = value
    } else if (className.startsWith('mx-')) {
      const token: string = className.substring(3)
      const value: number = this.getSpacingValue(token)
      styles.marginLeft = value
      styles.marginRight = value
    } else if (className.startsWith('my-')) {
      const token: string = className.substring(3)
      const value: number = this.getSpacingValue(token)
      styles.marginTop = value
      styles.marginBottom = value
    }
    // 宽度
    else if (className.startsWith('w-')) {
      const token: string = className.substring(2)
      styles.width = this.getArbitraryOrWidth(token)
    }
    // 高度
    else if (className.startsWith('h-')) {
      const token: string = className.substring(2)
      styles.height = this.getArbitraryOrHeight(token)
    }
    // 背景色
    else if (className.startsWith('bg-')) {
      const token: string = className.substring(3)
      styles.backgroundColor = this.getArbitraryOrColor(token)
    }
    // 文本样式（颜色/字号）
    else if (className.startsWith('text-')) {
      const token: string = className.substring(5) // e.g. 'green-400' | '2xl' | 'center'
      if (this.isArbitrary(token)) {
        const size = this.parseLengthToken(this.stripBrackets(token))
        if (typeof size === 'number') {
          styles.fontSize = size
        }
      } else if (this.isTextSizeToken(token)) {
        styles.fontSize = this.getFontSizeValue(className)
      } else if (token === 'left' || token === 'center' || token === 'right' || token === 'justify') {
        // 文本对齐在后续分支也会处理，这里跳过
      } else {
        styles.fontColor = this.getArbitraryOrColor(token)
      }
    }
    // 字体粗细
    else if (className.startsWith('font-')) {
      styles.fontWeight = this.getFontWeightValue(className.substring(5))
    }
    // 圆角
    else if (className.startsWith('rounded')) {
      styles.borderRadius = this.getBorderRadiusValue(className)
    }
    // 主轴对齐（Row/Column 通用）
    else if (className.startsWith('justify-')) {
      const token: string = className.substring(8) // start/center/end/between/around/evenly
      styles.justifyContent = this.getJustifyValue(token)
    }
    // 交叉轴对齐（Row/Column 通用）
    else if (className.startsWith('items-')) {
      const token: string = className.substring(6) // start/center/end/stretch/baseline
      styles.alignItems = this.getAlignItemsValue(token)
    }
    // 阴影
    else if (className.startsWith('shadow')) {
      styles.shadow = this.getShadowValue(className)
    }
    // 边框
    else if (className.startsWith('border')) {
      const borderStyle: BorderStyle = this.getBorderValue(className)
      styles.borderWidth = borderStyle.borderWidth
      if (borderStyle.borderColor) {
        styles.borderColor = borderStyle.borderColor
      }
    }
    // 不透明度
    else if (className.startsWith('opacity-')) {
      const token: string = className.substring(8)
      styles.opacity = this.getOpacityValue(token)
    }
    // 行高（仅文本）
    else if (className.startsWith('leading-')) {
      const token: string = className.substring(8)
      const lh = this.parseLengthToken(this.stripBrackets(token))
      if (typeof lh === 'number') {
        styles.lineHeight = lh
      }
    }
    // 文本对齐
    else if (className.startsWith('text-') && className.includes('center')) {
      styles.textAlign = TextAlign.Center
    } else if (className.startsWith('text-') && className.includes('left')) {
      styles.textAlign = TextAlign.Start
    } else if (className.startsWith('text-') && className.includes('right')) {
      styles.textAlign = TextAlign.End
    }
  }

  private getSpacingValue(value: string): number {
    const spacingMap: Map<string, number> = new Map([
      ['0', 0], ['1', 4], ['2', 8], ['3', 12], ['4', 16],
      ['5', 20], ['6', 24], ['8', 32], ['10', 40], ['12', 48]
    ])
    return spacingMap.get(value) || 0
  }

  private getWidthValue(value: string): string | number {
    if (value === 'full') return '100%'
    if (value === 'auto') return 'auto'
    if (value === '1/2') return '50%'
    if (value === '1/3') return '33.333333%'
    if (value === '2/3') return '66.666667%'
    if (value === '1/4') return '25%'
    if (value === '3/4') return '75%'
    return this.getSpacingValue(value)
  }

  private getHeightValue(value: string): string | number {
    if (value === 'full') return '100%'
    if (value === 'auto') return 'auto'
    if (value === 'screen') return '100vh'
    return this.getSpacingValue(value)
  }

  private getColorValue(colorClass: string): string {
    const colorMap: Map<string, string> = new Map([
      // 灰色系
      ['gray-50', '#f9fafb'], ['gray-100', '#f3f4f6'], ['gray-200', '#e5e7eb'],
      ['gray-300', '#d1d5db'], ['gray-400', '#9ca3af'], ['gray-500', '#6b7280'],
      ['gray-600', '#4b5563'], ['gray-700', '#374151'], ['gray-800', '#1f2937'],
      ['gray-900', '#111827'],
      // slate
      ['slate-50', '#f8fafc'], ['slate-100', '#f1f5f9'], ['slate-200', '#e2e8f0'],
      ['slate-300', '#cbd5e1'], ['slate-400', '#94a3b8'], ['slate-500', '#64748b'],
      ['slate-600', '#475569'], ['slate-700', '#334155'], ['slate-800', '#1e293b'],
      ['slate-900', '#0f172a'],
      // zinc
      ['zinc-50', '#fafafa'], ['zinc-100', '#f4f4f5'], ['zinc-200', '#e4e4e7'],
      ['zinc-300', '#d4d4d8'], ['zinc-400', '#a1a1aa'], ['zinc-500', '#71717a'],
      ['zinc-600', '#52525b'], ['zinc-700', '#3f3f46'], ['zinc-800', '#27272a'],
      ['zinc-900', '#18181b'],
      // neutral
      ['neutral-50', '#fafafa'], ['neutral-100', '#f5f5f5'], ['neutral-200', '#e5e5e5'],
      ['neutral-300', '#d4d4d4'], ['neutral-400', '#a3a3a3'], ['neutral-500', '#737373'],
      ['neutral-600', '#525252'], ['neutral-700', '#404040'], ['neutral-800', '#262626'],
      ['neutral-900', '#171717'],
      // stone
      ['stone-50', '#fafaf9'], ['stone-100', '#f5f5f4'], ['stone-200', '#e7e5e4'],
      ['stone-300', '#d6d3d1'], ['stone-400', '#a8a29e'], ['stone-500', '#78716c'],
      ['stone-600', '#57534e'], ['stone-700', '#44403c'], ['stone-800', '#292524'],
      ['stone-900', '#1c1917'],
      // 蓝色系
      ['blue-50', '#eff6ff'], ['blue-100', '#dbeafe'], ['blue-200', '#bfdbfe'],
      ['blue-300', '#93c5fd'], ['blue-400', '#60a5fa'], ['blue-500', '#3b82f6'],
      ['blue-600', '#2563eb'], ['blue-700', '#1d4ed8'], ['blue-800', '#1e40af'],
      ['blue-900', '#1e3a8a'],
      // sky
      ['sky-50', '#f0f9ff'], ['sky-100', '#e0f2fe'], ['sky-200', '#bae6fd'],
      ['sky-300', '#7dd3fc'], ['sky-400', '#38bdf8'], ['sky-500', '#0ea5e9'],
      ['sky-600', '#0284c7'], ['sky-700', '#0369a1'], ['sky-800', '#075985'],
      ['sky-900', '#0c4a6e'],
      // indigo
      ['indigo-50', '#eef2ff'], ['indigo-100', '#e0e7ff'], ['indigo-200', '#c7d2fe'],
      ['indigo-300', '#a5b4fc'], ['indigo-400', '#818cf8'], ['indigo-500', '#6366f1'],
      ['indigo-600', '#4f46e5'], ['indigo-700', '#4338ca'], ['indigo-800', '#3730a3'],
      ['indigo-900', '#312e81'],
      // violet
      ['violet-50', '#f5f3ff'], ['violet-100', '#ede9fe'], ['violet-200', '#ddd6fe'],
      ['violet-300', '#c4b5fd'], ['violet-400', '#a78bfa'], ['violet-500', '#8b5cf6'],
      ['violet-600', '#7c3aed'], ['violet-700', '#6d28d9'], ['violet-800', '#5b21b6'],
      ['violet-900', '#4c1d95'],
      // purple
      ['purple-50', '#faf5ff'], ['purple-100', '#f3e8ff'], ['purple-200', '#e9d5ff'],
      ['purple-300', '#d8b4fe'], ['purple-400', '#c084fc'], ['purple-500', '#a855f7'],
      ['purple-600', '#9333ea'], ['purple-700', '#7e22ce'], ['purple-800', '#6b21a8'],
      ['purple-900', '#581c87'],
      // fuchsia
      ['fuchsia-50', '#fdf4ff'], ['fuchsia-100', '#fae8ff'], ['fuchsia-200', '#f5d0fe'],
      ['fuchsia-300', '#f0abfc'], ['fuchsia-400', '#e879f9'], ['fuchsia-500', '#d946ef'],
      ['fuchsia-600', '#c026d3'], ['fuchsia-700', '#a21caf'], ['fuchsia-800', '#86198f'],
      ['fuchsia-900', '#701a75'],
      // 红色系
      ['red-50', '#fef2f2'], ['red-100', '#fee2e2'], ['red-200', '#fecaca'],
      ['red-300', '#fca5a5'], ['red-400', '#f87171'], ['red-500', '#ef4444'],
      ['red-600', '#dc2626'], ['red-700', '#b91c1c'], ['red-800', '#991b1b'],
      ['red-900', '#7f1d1d'],
      // pink
      ['pink-50', '#fdf2f8'], ['pink-100', '#fce7f3'], ['pink-200', '#fbcfe8'],
      ['pink-300', '#f9a8d4'], ['pink-400', '#f472b6'], ['pink-500', '#ec4899'],
      ['pink-600', '#db2777'], ['pink-700', '#be185d'], ['pink-800', '#9d174d'],
      ['pink-900', '#831843'],
      // rose
      ['rose-50', '#fff1f2'], ['rose-100', '#ffe4e6'], ['rose-200', '#fecdd3'],
      ['rose-300', '#fda4af'], ['rose-400', '#fb7185'], ['rose-500', '#f43f5e'],
      ['rose-600', '#e11d48'], ['rose-700', '#be123c'], ['rose-800', '#9f1239'],
      ['rose-900', '#881337'],
      // 绿色系
      ['green-50', '#f0fdf4'], ['green-100', '#dcfce7'], ['green-200', '#bbf7d0'],
      ['green-300', '#86efac'], ['green-400', '#4ade80'], ['green-500', '#22c55e'],
      ['green-600', '#16a34a'], ['green-700', '#15803d'], ['green-800', '#166534'],
      ['green-900', '#14532d'],
      // lime
      ['lime-50', '#f7fee7'], ['lime-100', '#ecfccb'], ['lime-200', '#d9f99d'],
      ['lime-300', '#bef264'], ['lime-400', '#a3e635'], ['lime-500', '#84cc16'],
      ['lime-600', '#65a30d'], ['lime-700', '#4d7c0f'], ['lime-800', '#3f6212'],
      ['lime-900', '#365314'],
      // emerald
      ['emerald-50', '#ecfdf5'], ['emerald-100', '#d1fae5'], ['emerald-200', '#a7f3d0'],
      ['emerald-300', '#6ee7b7'], ['emerald-400', '#34d399'], ['emerald-500', '#10b981'],
      ['emerald-600', '#059669'], ['emerald-700', '#047857'], ['emerald-800', '#065f46'],
      ['emerald-900', '#064e3b'],
      // teal
      ['teal-50', '#f0fdfa'], ['teal-100', '#ccfbf1'], ['teal-200', '#99f6e4'],
      ['teal-300', '#5eead4'], ['teal-400', '#2dd4bf'], ['teal-500', '#14b8a6'],
      ['teal-600', '#0d9488'], ['teal-700', '#0f766e'], ['teal-800', '#115e59'],
      ['teal-900', '#134e4a'],
      // cyan
      ['cyan-50', '#ecfeff'], ['cyan-100', '#cffafe'], ['cyan-200', '#a5f3fc'],
      ['cyan-300', '#67e8f9'], ['cyan-400', '#22d3ee'], ['cyan-500', '#06b6d4'],
      ['cyan-600', '#0891b2'], ['cyan-700', '#0e7490'], ['cyan-800', '#155e75'],
      ['cyan-900', '#164e63'],
      // 黄、橙、琥珀
      ['yellow-50', '#fefce8'], ['yellow-100', '#fef9c3'], ['yellow-200', '#fef08a'],
      ['yellow-300', '#fde047'], ['yellow-400', '#facc15'], ['yellow-500', '#eab308'],
      ['yellow-600', '#ca8a04'], ['yellow-700', '#a16207'], ['yellow-800', '#854d0e'],
      ['yellow-900', '#713f12'],
      ['amber-50', '#fffbeb'], ['amber-100', '#fef3c7'], ['amber-200', '#fde68a'],
      ['amber-300', '#fcd34d'], ['amber-400', '#fbbf24'], ['amber-500', '#f59e0b'],
      ['amber-600', '#d97706'], ['amber-700', '#b45309'], ['amber-800', '#92400e'],
      ['amber-900', '#78350f'],
      ['orange-50', '#fff7ed'], ['orange-100', '#ffedd5'], ['orange-200', '#fed7aa'],
      ['orange-300', '#fdba74'], ['orange-400', '#fb923c'], ['orange-500', '#f97316'],
      ['orange-600', '#ea580c'], ['orange-700', '#c2410c'], ['orange-800', '#9a3412'],
      ['orange-900', '#7c2d12'],
      // brown（非标准 Tailwind，提供扩展示例，可按需删除）
      ['brown-50', '#efebe9'], ['brown-100', '#d7ccc8'], ['brown-200', '#bcaaa4'],
      ['brown-300', '#a1887f'], ['brown-400', '#8d6e63'], ['brown-500', '#795548'],
      ['brown-600', '#6d4c41'], ['brown-700', '#5d4037'], ['brown-800', '#4e342e'],
      ['brown-900', '#3e2723'],
      // 基础色
      ['white', '#ffffff'], ['black', '#000000'], ['transparent', 'transparent']
    ])
    return colorMap.get(colorClass) || '#000000'
  }

  private getArbitraryOrColor(token: string): string {
    if (this.isArbitrary(token)) {
      const raw = this.stripBrackets(token)
      // 支持 #RRGGBB/#AARRGGBB
      if (raw.startsWith('#')) {
        return raw
      }
    }
    return this.getColorValue(token)
  }

  private getFontSizeValue(className: string): number {
    const fontSizeMap: Map<string, number> = new Map([
      ['text-xs', 12], ['text-sm', 14], ['text-base', 16], ['text-lg', 18],
      ['text-xl', 20], ['text-2xl', 24], ['text-3xl', 30], ['text-4xl', 36],
      ['text-5xl', 48], ['text-6xl', 60]
    ])
    return fontSizeMap.get(className) || 16
  }

  private isTextSizeToken(token: string): boolean {
    // token: 'xs' | 'sm' | 'base' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl' | '5xl' | '6xl'
    switch (token) {
      case 'xs':
      case 'sm':
      case 'base':
      case 'lg':
      case 'xl':
      case '2xl':
      case '3xl':
      case '4xl':
      case '5xl':
      case '6xl':
        return true
      default:
        return false
    }
  }

  private isArbitrary(token: string): boolean {
    return token.startsWith('[') && token.endsWith(']')
  }

  private stripBrackets(token: string): string {
    return token.substring(1, token.length - 1)
  }

  private parseLengthToken(raw: string): string | number {
    // 支持 18px / 12vp / 50% / 24
    if (raw.endsWith('px') || raw.endsWith('vp')) {
      const num = parseFloat(raw.slice(0, -2))
      return isNaN(num) ? 0 : num
    }
    if (raw.endsWith('%')) {
      return raw
    }
    const n = parseFloat(raw)
    return isNaN(n) ? 0 : n
  }

  private getArbitraryOrWidth(token: string): string | number {
    if (this.isArbitrary(token)) {
      return this.parseLengthToken(this.stripBrackets(token))
    }
    return this.getWidthValue(token)
  }

  private getArbitraryOrHeight(token: string): string | number {
    if (this.isArbitrary(token)) {
      return this.parseLengthToken(this.stripBrackets(token))
    }
    return this.getHeightValue(token)
  }

  private getOpacityValue(token: string): number {
    // 支持 0/5/10/.../100 以及任意值语法 [0.35]
    if (this.isArbitrary(token)) {
      const raw: string = this.stripBrackets(token)
      const v: number = parseFloat(raw)
      return isNaN(v) ? 1 : Math.min(Math.max(v, 0), 1)
    }
    switch (token) {
      case '0': return 0
      case '5': return 0.05
      case '10': return 0.1
      case '20': return 0.2
      case '25': return 0.25
      case '30': return 0.3
      case '40': return 0.4
      case '50': return 0.5
      case '60': return 0.6
      case '70': return 0.7
      case '75': return 0.75
      case '80': return 0.8
      case '90': return 0.9
      case '95': return 0.95
      case '100': return 1
      default: return 1
    }
  }

  private getFontWeightValue(weight: string): FontWeight {
    // ArkUI 支持 Normal / Medium / Bold，其余全部降级为 Normal
    switch (weight) {
      case 'medium':
        return FontWeight.Medium
      case 'semibold':
      case 'bold':
      case 'extrabold':
      case 'black':
        return FontWeight.Bold
      default:
        return FontWeight.Normal
    }
  }

  private getBorderRadiusValue(className: string): number {
    const radiusMap: Map<string, number> = new Map([
      ['rounded-none', 0], ['rounded-sm', 2], ['rounded', 4], ['rounded-md', 6],
      ['rounded-lg', 8], ['rounded-xl', 12], ['rounded-2xl', 16], ['rounded-3xl', 24],
      ['rounded-full', 9999]
    ])
    return radiusMap.get(className) || 0
  }

  private getShadowValue(className: string): ShadowStyle {
    // 使用 ArkUI 规范的颜色字面量（#AARRGGBB），避免 rgba() 字符串
    // 并采用 switch 避免在运行期频繁创建 Map
    switch (className) {
      case 'shadow-sm':
        return new ShadowOptions(2, '#0D000000', 0, 1)
      case 'shadow':
        return new ShadowOptions(4, '#1A000000', 0, 2)
      case 'shadow-md':
        return new ShadowOptions(6, '#1A000000', 0, 4)
      case 'shadow-lg':
        return new ShadowOptions(8, '#1A000000', 0, 6)
      case 'shadow-xl':
        return new ShadowOptions(12, '#1A000000', 0, 8)
      case 'shadow-2xl':
        return new ShadowOptions(16, '#40000000', 0, 12)
      default:
        return new ShadowOptions(0, 'transparent', 0, 0)
    }
  }

  private getBorderValue(className: string): BorderStyle {
    if (className === 'border') {
      return { borderWidth: 1 }
    }
    if (className.startsWith('border-')) {
      const token: string = className.substring(7)
      const numeric: number = parseInt(token)
      if (!isNaN(numeric)) {
        return { borderWidth: numeric }
      }
      // 颜色令牌
      return { borderWidth: 1, borderColor: this.getColorValue(token) }
    }
    return { borderWidth: 0 }
  }

  private getJustifyValue(token: string): FlexAlign {
    switch (token) {
      case 'center':
        return FlexAlign.Center
      case 'end':
        return FlexAlign.End
      case 'between':
        return FlexAlign.SpaceBetween
      case 'around':
        return FlexAlign.SpaceAround
      case 'evenly':
        return FlexAlign.SpaceEvenly
      case 'start':
      default:
        return FlexAlign.Start
    }
  }

  private getAlignItemsValue(token: string): HorizontalAlign {
    switch (token) {
      case 'center':
        return HorizontalAlign.Center
      case 'end':
        return HorizontalAlign.End
      // ArkUI 无 baseline/stretch 枚举，降级为 Start
      case 'baseline':
      case 'stretch':
      case 'start':
      default:
        return HorizontalAlign.Start
    }
  }
}

/**
 * 阴影样式接口
 */
export interface ShadowStyle {
  radius: number
  color: string
  offsetX: number
  offsetY: number
}

export class ShadowOptions implements ShadowStyle {
  radius: number
  color: string
  offsetX: number
  offsetY: number
  constructor(radius: number, color: string, offsetX: number, offsetY: number) {
    this.radius = radius
    this.color = color
    this.offsetX = offsetX
    this.offsetY = offsetY
  }
}

/**
 * 边框样式接口
 */
export interface BorderStyle {
  borderWidth: number
  borderColor?: string
}

/**
 * Tailwind样式接口
 */
export interface TailwindStyles {
  padding?: number
  paddingLeft?: number
  paddingRight?: number
  paddingTop?: number
  paddingBottom?: number
  margin?: number
  marginLeft?: number
  marginRight?: number
  marginTop?: number
  marginBottom?: number
  width?: string | number
  height?: string | number
  backgroundColor?: string
  opacity?: number
  fontColor?: string
  fontSize?: number
  lineHeight?: number
  fontWeight?: FontWeight
  borderRadius?: number
  shadow?: ShadowStyle
  borderWidth?: number
  borderColor?: string
  textAlign?: TextAlign
  justifyContent?: FlexAlign
  alignItems?: HorizontalAlign
}