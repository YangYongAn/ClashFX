## ClashFX 1.0.20

### Performance / 性能

- **Fixed UI freeze when toggling Enhanced Mode with many proxy groups** — Toggling Enhanced Mode (TUN) on configurations with many proxy groups (30+ groups, hundreds of proxies) caused the UI to freeze for several seconds with CPU at 100%. The toggle path no longer forces a full menu rebuild on every switch — it now uses lightweight refresh when proxy topology is unchanged, and only rebuilds when group structure actually changes. Removed unnecessary 1-second delay chains.
- **Fixed proxy list disappearing after toggling Enhanced Mode** — After turning Enhanced Mode off, the proxy group list could become empty, requiring a manual config switch to restore it. The proxy data cache is now properly updated after each topology change.

### Bug Fixes / 问题修复

- **Fixed Main Thread Checker warning on app quit** — `NSApp.reply(toApplicationShouldTerminate:)` was called from a background queue during cleanup, which could cause UI inconsistencies. All termination replies are now properly dispatched to the main thread.

---

### 性能

- **修复规则数量多时切换增强模式卡顿** — 在节点组很多（30+ 组、上百节点）的配置下切换增强模式（TUN），UI 会卡顿数秒、CPU 飙到 100%。现在切换时不再强制重建整个菜单，节点结构未变时使用轻量刷新，仅在节点组结构真正变化时才重建。同时去除了不必要的 1 秒延迟链。
- **修复关闭增强模式后规则列表消失** — 关闭增强模式后，节点组列表可能变空，需要手动切换配置才能恢复。修复了切换后节点数据缓存未正确更新的问题。

### 问题修复

- **修复退出时主线程检查警告** — `NSApp.reply(toApplicationShouldTerminate:)` 在清理过程中被从后台队列调用，可能导致 UI 不一致。现在所有终止响应都正确派发到主线程。

---

[![Download ClashFX](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/clashfx/files/1.0.20/)
