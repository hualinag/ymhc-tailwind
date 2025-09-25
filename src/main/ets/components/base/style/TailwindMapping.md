# Tailwind → ArkUI 样式映射与支持说明

本文件汇总 `TailwindStyleParser.ets` 与 `TailwindAttributeModifier.ets` 已支持的 Tailwind 类名映射规则，便于配置与查阅。所有实现均强类型（无 any/unknown），符合 ArkUI/ArkTS 规范。

## 覆盖优先级
1. 组件默认值 → 2. 主题/系统模式 → 3. 组件入参 → 4. `.attributeModifier(tw('...'))`（最终覆盖）

---

## 间距（Spacing）
- 语法：`p-{n}`、`px-{n}`、`py-{n}`、`m-{n}`、`mx-{n}`、`my-{n}`
- n（单位 vp）：`0, 1(4), 2(8), 3(12), 4(16), 5(20), 6(24), 8(32), 10(40), 12(48)`
- 映射：
  - `p-{n}` → `padding(n)`
  - `px-{n}` → `paddingLeft(n)` + `paddingRight(n)`
  - `py-{n}` → `paddingTop(n)` + `paddingBottom(n)`
  - `m-{n}` → `margin(n)`
  - `mx-{n}` → `marginLeft(n)` + `marginRight(n)`
  - `my-{n}` → `marginTop(n)` + `marginBottom(n)`

---

## 尺寸（Sizing）
- 宽度：`w-{token}`，高度：`h-{token}`
- 特殊：`full(100%)`、`auto`
- 分数：`1/2(50%)`、`1/3(33.33%)`、`2/3(66.66%)`、`1/4(25%)`、`3/4(75%)`
- 任意值：`w-[120px]`、`h-[50%]`、`w-[24vp]`、`w-[120]`（数字按 vp）
- 映射：`width(...)` / `height(...)`

---

## 颜色（Colors）
- 背景：`bg-*` → `backgroundColor(...)`
- 文本：`text-*`（非字号/对齐）→ `fontColor(...)`
- 颜色家族（50..900）：
  - 灰度：`gray`、`slate`、`zinc`、`neutral`、`stone`
  - 蓝系：`blue`、`sky`、`indigo`、`violet`、`purple`、`fuchsia`、`cyan`
  - 红粉：`red`、`pink`、`rose`
  - 绿系：`green`、`emerald`、`teal`、`lime`
  - 黄橙：`yellow`、`amber`、`orange`
  - 扩展：`brown`（可选）
- 基础色：`white`、`black`、`transparent`
- 任意色：`bg-[#RRGGBB]`、`bg-[#AARRGGBB]`

---

## 文本（Typography）
- 字号：`text-xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl` 或 `text-[18px]` → `fontSize(...)`
- 字重：`font-...` → `fontWeight(...)`
  - ArkUI：`Normal / Medium / Bold`（其余降级 `Normal`）
- 行高：`leading-[24px]` → `lineHeight(...)`
- 对齐：`text-left|center|right|justify` → `textAlign(...)`

---

## 对齐（Flex Alignment）
- 主轴：`justify-start|center|end|between|around|evenly` → `justifyContent(FlexAlign.*)`
- 交叉轴：`items-start|center|end|baseline|stretch` → `alignItems(HorizontalAlign.*)`（baseline/stretch 降级为 Start）

---

## 边框（Border）
- 宽度：`border`(1) / `border-2|4|8` → `border({ width })`
- 颜色：`border-green-400` → `borderColor`（在修饰器里合并应用）

---

## 阴影（Shadow）
- 类：`shadow-sm|DEFAULT|md|lg|xl|2xl`
- ArkUI 颜色：`#AARRGGBB`；使用 `ShadowOptions` 强类型
- 映射：`shadow(new ShadowOptions(radius, color, offsetX, offsetY))`

---

## 透明度（Opacity）
- 预设：`opacity-0|5|10|20|25|30|40|50|60|70|75|80|90|95|100`
- 任意：`opacity-[0.35]`
- 映射：`opacity(number[0..1])`

---

## 任意值（Arbitrary Values）
- 语法：`[value]`，支持 `px`、`vp`、`%`、纯数字（视作 vp）
- 适用：`w-[..]`、`h-[..]`、`text-[..]`、`leading-[..]`、`bg-[#..]`

---

## 示例
```ets
Column()
  .attributeModifier(tw('w-[100%] h-[120vp] bg-white rounded-lg shadow-md p-4 opacity-95 justify-between items-center'))
{
  Text('标题')
    .attributeModifier(tw('text-2xl font-bold text-blue-600 leading-[28px]'))
  Text('说明')
    .attributeModifier(tw('text-sm text-gray-600'))
}
```

---

## 约束与扩展
- 若 ArkUI 有固定枚举（如 `FlexAlign.SpaceEvenly`），优先使用 ArkUI 枚举值。
- 不在 build 中创建临时变量；对象参数使用显式类（如 `ShadowOptions`）。
- 需新增 token（如 gap/overflow/z-index/定位等），可按本规范继续扩展。

---

## 🎯 对照速查（Tailwind ↔ ArkUI）

### 🔤 Typography（字号/字重/行高/对齐）

| Tailwind            | ArkUI                                      | 说明 |
|---------------------|--------------------------------------------|-----|
| `text-sm`           | `fontSize(14)`                             | 尺寸对照见上表 |
| `text-[18px]`       | `fontSize(18)`                             | 任意值 |
| `font-normal`       | `fontWeight(FontWeight.Normal)`            | thin/light 等均降级 Normal |
| `font-medium`       | `fontWeight(FontWeight.Medium)`            |      |
| `font-bold`         | `fontWeight(FontWeight.Bold)`              | semibold/extrabold/black → Bold |
| `leading-[24px]`    | `lineHeight(24)`                           | 任意值 |
| `text-left`         | `textAlign(TextAlign.Start)`               |      |
| `text-center`       | `textAlign(TextAlign.Center)`              |      |
| `text-right`        | `textAlign(TextAlign.End)`                 |      |

### 📐 Spacing（内/外边距）

| Tailwind  | ArkUI                                              |
|-----------|----------------------------------------------------|
| `p-4`     | `padding(16)`                                      |
| `px-3`    | `paddingLeft(12)` + `paddingRight(12)`             |
| `py-2`    | `paddingTop(8)` + `paddingBottom(8)`               |
| `m-6`     | `margin(24)`                                       |
| `mx-8`    | `marginLeft(32)` + `marginRight(32)`               |
| `my-1`    | `marginTop(4)` + `marginBottom(4)`                 |

### 📦 Sizing（宽高）

| Tailwind     | ArkUI                 | 说明 |
|--------------|-----------------------|-----|
| `w-full`     | `width('100%')`       |     |
| `w-1/2`      | `width('50%')`        |     |
| `h-auto`     | `height('auto')`      |     |
| `w-[120px]`  | `width(120)`          | 任意值（px/vp/%/数字） |
| `h-[50%]`    | `height('50%')`       |     |

### 🧭 Flex 对齐

| Tailwind            | ArkUI                                |
|---------------------|--------------------------------------|
| `justify-start`     | `justifyContent(FlexAlign.Start)`    |
| `justify-center`    | `justifyContent(FlexAlign.Center)`   |
| `justify-end`       | `justifyContent(FlexAlign.End)`      |
| `justify-between`   | `justifyContent(FlexAlign.SpaceBetween)` |
| `justify-around`    | `justifyContent(FlexAlign.SpaceAround)`  |
| `justify-evenly`    | `justifyContent(FlexAlign.SpaceEvenly)`  |
| `items-start`       | `alignItems(HorizontalAlign.Start)`  |
| `items-center`      | `alignItems(HorizontalAlign.Center)` |
| `items-end`         | `alignItems(HorizontalAlign.End)`    |

### 🎨 Colors（颜色对照与指示）

> 色块仅用于文档直观显示，实际颜色以映射表为准。

| 家族 | 示例 | Hex | 预览 |
|------|------|-----|------|
| slate | `slate-500` | `#64748b` | <span style="display:inline-block;width:14px;height:14px;background:#64748b;border:1px solid #ccc"></span> |
| blue  | `blue-600`  | `#2563eb` | <span style="display:inline-block;width:14px;height:14px;background:#2563eb;border:1px solid #ccc"></span> |
| indigo| `indigo-500`| `#6366f1` | <span style="display:inline-block;width:14px;height:14px;background:#6366f1;border:1px solid #ccc"></span> |
| emerald| `emerald-500`| `#10b981`| <span style="display:inline-block;width:14px;height:14px;background:#10b981;border:1px solid #ccc"></span> |
| amber | `amber-400` | `#fbbf24` | <span style="display:inline-block;width:14px;height:14px;background:#fbbf24;border:1px solid #ccc"></span> |
| rose  | `rose-500`  | `#f43f5e` | <span style="display:inline-block;width:14px;height:14px;background:#f43f5e;border:1px solid #ccc"></span> |

使用示例：

```ets
Column().attributeModifier(tw('bg-emerald-50'))
Text('状态').attributeModifier(tw('text-rose-500'))
```

### 🧊 Opacity（不透明度）

| Tailwind | 0 | 5 | 10 | 20 | 25 | 30 | 40 | 50 | 60 | 70 | 75 | 80 | 90 | 95 | 100 |
|----------|---|---|----|----|----|----|----|----|----|----|----|----|----|----|-----|
| value    | 0 | .05 | .1 | .2 | .25 | .3 | .4 | .5 | .6 | .7 | .75 | .8 | .9 | .95 | 1 |

任意值：`opacity-[0.35]` → 0.35。

### 🌫 Shadow（阴影）

| Tailwind   | ArkUI ShadowOptions（示例）               |
|------------|------------------------------------------|
| shadow-sm  | radius:2 color:#0D000000 offset:(0,1)    |
| shadow     | radius:4 color:#1A000000 offset:(0,2)    |
| shadow-md  | radius:6 color:#1A000000 offset:(0,4)    |
| shadow-lg  | radius:8 color:#1A000000 offset:(0,6)    |
| shadow-xl  | radius:12 color:#1A000000 offset:(0,8)   |
| shadow-2xl | radius:16 color:#40000000 offset:(0,12)  |

---

## 🧩 ArkUI 链式对照示例

```ets
// Tailwind → ArkUI 属性调用（最终放在链式末尾）
Column() {
  Text('标题').attributeModifier(tw('text-2xl font-bold text-blue-600'))
}
.attributeModifier(tw('bg-white rounded-lg shadow-md p-4 w-full justify-between items-center'))
```

---

## 详细映射表（更精细化）

### Spacing 尺寸刻度（n → vp）

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 8 | 10 | 12 |
|---|---|---|---|---|---|---|---|---|----|----|
| vp | 0 | 4 | 8 | 12 | 16 | 20 | 24 | 32 | 40 | 48 |

用法：
- `p-n` → `padding(n)`；`px-n` → `paddingLeft/Right(n)`；`py-n` → `paddingTop/Bottom(n)`
- `m-n` → `margin(n)`；`mx-n` → `marginLeft/Right(n)`；`my-n` → `marginTop/Bottom(n)`

### Typography 字号（text-* → fontSize）

| Tailwind | xs | sm | base | lg | xl | 2xl | 3xl | 4xl | 5xl | 6xl |
|----------|----|----|------|----|----|-----|-----|-----|-----|-----|
| fontSize | 12 | 14 | 16   | 18 | 20 | 24  | 30  | 36  | 48  | 60  |

任意值：`text-[18px]` → 18。

### Typography 字重（font-* → fontWeight）

| Tailwind              | ArkUI |
|-----------------------|-------|
| thin/extralight/light/normal | FontWeight.Normal |
| medium                | FontWeight.Medium |
| semibold/bold/extrabold/black | FontWeight.Bold |

### 文本对齐（text-align）

| Tailwind      | ArkUI                      |
|---------------|----------------------------|
| text-left     | TextAlign.Start            |
| text-center   | TextAlign.Center           |
| text-right    | TextAlign.End              |
| text-justify  | TextAlign.Justify（如生效）|

### Flex 对齐（Row/Column）

| Tailwind            | ArkUI                          |
|---------------------|--------------------------------|
| justify-start       | FlexAlign.Start                |
| justify-center      | FlexAlign.Center               |
| justify-end         | FlexAlign.End                  |
| justify-between     | FlexAlign.SpaceBetween         |
| justify-around      | FlexAlign.SpaceAround          |
| justify-evenly      | FlexAlign.SpaceEvenly          |
| items-start         | HorizontalAlign.Start          |
| items-center        | HorizontalAlign.Center         |
| items-end           | HorizontalAlign.End            |
| items-baseline/stretch | HorizontalAlign.Start（降级）|

### 边框（border-*）

| Tailwind 示例          | 解析结果                                 |
|------------------------|------------------------------------------|
| border                 | borderWidth: 1                           |
| border-2 / 4 / 8       | borderWidth: 2 / 4 / 8                   |
| border-amber-400       | borderWidth: 1 + borderColor: amber-400  |

在修饰器中：`border({ width })` 与 `borderColor` 合并应用。

### 背景与文本颜色（color families）

支持 `gray/slate/zinc/neutral/stone/blue/sky/indigo/violet/purple/fuchsia/cyan/red/pink/rose/green/emerald/teal/lime/yellow/amber/orange` 的 50..900；
基础 `white/black/transparent`；任意色 `[#RRGGBB]/[#AARRGGBB]`。

### 透明度（opacity-*）

| Tailwind | 0 | 5 | 10 | 20 | 25 | 30 | 40 | 50 | 60 | 70 | 75 | 80 | 90 | 95 | 100 |
|----------|---|---|----|----|----|----|----|----|----|----|----|----|----|----|-----|
| value    | 0 | .05 | .1 | .2 | .25 | .3 | .4 | .5 | .6 | .7 | .75 | .8 | .9 | .95 | 1 |

任意值：`opacity-[0.35]` → 0.35。

### 阴影（shadow-*）

| Tailwind   | ArkUI ShadowOptions（示意）                 |
|------------|--------------------------------------------|
| shadow-sm  | radius:2 color:#0D000000 offset:(0,1)      |
| shadow     | radius:4 color:#1A000000 offset:(0,2)      |
| shadow-md  | radius:6 color:#1A000000 offset:(0,4)      |
| shadow-lg  | radius:8 color:#1A000000 offset:(0,6)      |
| shadow-xl  | radius:12 color:#1A000000 offset:(0,8)     |
| shadow-2xl | radius:16 color:#40000000 offset:(0,12)    |

> ArkUI 颜色采用 `#AARRGGBB`，如需调整强度，建议改 `alpha` 或 `radius`。

### 任意值（Arbitrary Values）

语法：`[value]`，支持：
- 长度：`px`、`vp`、`%`、纯数字（视作 `vp`）
- 颜色：`#RRGGBB`、`#AARRGGBB`

适用：`w-[..]`、`h-[..]`、`text-[..]`、`leading-[..]`、`bg-[#..]`、`opacity-[..]`。

