## ClashFX 1.0.15

### New Features / 新功能

- **Added a Restart item above Quit in the tray menu** — ClashFX now provides a direct Restart action in the status menu, so users can reload the app and core without manually quitting and reopening.

- **Added tray menu item visibility controls in Appearance settings** — The new Tray Menu settings let users decide which sections and items stay visible in the tray, with parent/child toggles, automatic separator cleanup, and a macOS 10.14 checkbox fallback alongside `NSSwitch` on macOS 10.15+.

- **Added a Config Switcher toggle and completed ja/ru localizations for tray menu settings** — Dynamic config switch items can now be hidden independently, and the new tray menu settings are fully localized in Japanese and Russian.

- **Fixed CI compile regressions in the new tray menu settings UI** — Alignment and control-state access issues from review follow-up changes were corrected so the release build passes cleanly again.

---

### 新功能

- **在托盘菜单「退出」上方新增“重启”菜单项** — 现在可以直接从状态栏菜单重启 ClashFX，无需先退出再手动重新打开应用。

- **在外观设置中新增托盘菜单项可见性配置** — 新增 “Tray Menu” 设置区，可按分组或单项控制托盘菜单显示；父子开关联动、分隔线会自动收起，并在 macOS 10.14 上自动退化为复选框样式，在 macOS 10.15+ 使用 `NSSwitch`。

- **新增 Config Switcher 开关，并补齐日语 / 俄语本地化** — 现在可以单独控制动态配置切换项显示，同时补齐了新托盘菜单设置在日语和俄语下的完整文案。

- **修复新托盘菜单设置功能在 CI 中的编译问题** — 修正了对齐和控件状态访问等问题，确保正式发布构建流程可以稳定通过。

---

### Contributors / 贡献者

- **@ayangweb**

[![Download ClashFX](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/clashfx/files/1.0.15/)
