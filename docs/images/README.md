# 截图目录

当前三张 PNG 是**按实际布局数值渲染的预览**（不是手机实拍）：

- 源文件：`preview/main.html`、`preview/symbols.html`、`preview/about.html`
- 生成器：`make_previews.py`（颜色/圆角/间距取自 `decoded/res/`，符号图标直接引用
  `decoded/res/drawable-nodpi/sym_*.png`，标签取自 `arrays.xml`）
- 渲染方式：起一个本地 HTTP 服务（`python -m http.server`），浏览器打开后整页截图并裁到 412dp 宽

界面改动后重新生成：

```powershell
python make_previews.py
# 起服务 → 浏览器打开 docs/images/preview/*.html → 整页截图 → 覆盖同名 PNG
```

想换成真机截图：直接用同名 PNG 覆盖即可，其余文件不用动。

下面三个文件名是 README 引用的（`main.png` / `symbols.png` / `about.png`）：

| 文件名 | 内容 | 建议 |
|---|---|---|
| `main.png` | 主界面（含状态磁贴、启动按钮） | 竖屏原始截图 |
| `symbols.png` | APRS 图标下拉展开的样子 | 下拉可见时截图 |
| `about.png` | 版权页 | 滚到顶部截图 |

命名对上即可，格式 PNG/JPG 都行（若是 JPG，请把 README 里的扩展名一起改掉）。

建议：

- 宽度 ≥ 720px，直接放原图，不需要压缩
- 截图里**不要**出现真实呼号以外的个人信息（通知栏、其他 App 图标）
- 想加 GIF：放到 `docs/images/demo.gif`，在 README 的「截图」段落下加一行 `![demo](docs/images/demo.gif)`
