## ClashFX 1.0.19

### Bug Fixes / 问题修复

- **Fixed Enhanced Mode (TUN) DNS hijacking on macOS** — When TUN mode was enabled, DNS queries to the local router bypassed the TUN device entirely because private network addresses (192.168.x.x) are routed directly through the LAN interface. This caused DNS pollution from the GFW, breaking connectivity to blocked sites for applications like Node.js, Discord, and other tools that don't respect macOS system proxy settings. ClashFX now automatically overrides the system DNS to `198.18.0.2` (TUN fake-ip range) when Enhanced Mode is activated, and restores the original DNS when it's disabled. DNS cache is also flushed on both transitions.

### Important / 重要提示

- **Helper update required** — This release includes changes to the privileged helper (version 1.0 → 1.1). On first launch after update, ClashFX will prompt for your administrator password to reinstall the helper. This is required for the DNS fix to work automatically.

### Improvements / 改进

- **Automatic DNS cache flush** — DNS cache is now automatically flushed when enabling or disabling Enhanced Mode, preventing stale/poisoned DNS entries from causing connection failures.
- **DNS state cleanup on quit** — If the app is quit while Enhanced Mode is active, DNS settings are automatically restored to prevent leaving the system in a broken state.

---

### 问题修复

- **修复增强模式（TUN）的 DNS 劫持问题** — 开启 TUN 模式后，发往本地路由器（如 192.168.x.x）的 DNS 查询会绕过 TUN 设备，直接走局域网接口。这导致 DNS 被 GFW 污染，使 Node.js、Discord 等不识别 macOS 系统代理的应用无法连接被封锁的网站。ClashFX 现在会在开启增强模式时自动将系统 DNS 覆盖为 `198.18.0.2`（TUN fake-ip 范围），并在关闭时恢复原始 DNS。DNS 缓存也会在切换时自动刷新。

### 重要提示

- **需要更新辅助程序** — 本版本包含特权辅助程序的更新（版本 1.0 → 1.1）。更新后首次启动时，ClashFX 会要求输入管理员密码以重新安装辅助程序。这是 DNS 修复自动生效所必需的。

### 改进

- **自动刷新 DNS 缓存** — 开启或关闭增强模式时自动刷新 DNS 缓存，防止残留的污染 DNS 条目导致连接失败。
- **退出时自动清理 DNS** — 增强模式启用期间退出应用时，DNS 设置会自动恢复，避免系统处于异常状态。

---

[![Download ClashFX](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/clashfx/files/1.0.19/)
