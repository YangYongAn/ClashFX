## ClashFX 1.0.10

### New Features

- **Tray icon customization** — Added a new **Appearance** tab in Preferences with a tray icon picker. Users can now replace the macOS menu bar icon with any custom PNG image via drag-and-drop or file picker, with a Reset button to restore the default. Image is saved to `~/.config/clashfx/menuImage.png`. Resolves #5

### Improvements

- **Updated menu bar icon** — Replaced the status bar icon with a new cat side-profile silhouette design.

### Bug Fixes

- **Fix language switch dialog not reappearing after clicking "Later"** — When switching language and dismissing the restart prompt with "Later", clicking the same language again would no longer show the dialog. Language settings are now only persisted when the user confirms the restart. Fixes #15
- **Fix proxy selections lost after app restart** — Saved proxy group selections (e.g. which node was chosen for each proxy group) could be permanently deleted if the API call failed during startup (e.g. core not ready yet). The records are now preserved for retry on next reload.

---

### 新功能

- **托盘图标自定义** — 偏好设置中新增 **外观（Appearance）** 标签页，支持拖拽或点击选择自定义 PNG 图片作为菜单栏图标，点击重置按钮可恢复默认图标。图片保存至 `~/.config/clashfx/menuImage.png`。解决 #5

### 改进

- **更新菜单栏图标** — 将状态栏图标替换为全新的猫侧面剪影设计。

### Bug 修复

- **修复点击「稍后」后语言切换弹窗不再出现的问题** — 切换语言时点击「稍后」关闭重启提示后，再次点击相同语言不会弹出对话框。现已修复：仅在用户确认重启时才保存语言设置。修复 #15
- **修复重启后代理选择丢失的问题** — 启动时如果内核尚未就绪，API 调用失败会导致保存的代理组选择（如每个代理组选中的节点）被永久删除。现已修复：失败时保留记录，下次重载时重试。

---

### Contributors

Thanks to everyone who contributed to this release:

- @ayangweb — Tray icon customization (#17), language switch dialog fix (#16)

[![Download ClashFX](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/clashfx/files/1.0.10/)
