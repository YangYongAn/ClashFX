### Bug Fixes

- **Subscriptions** — Fixed an issue where raw base64 share-link subscriptions failed to import due to improper validation order.
- **Config Parser** — Tightened remote config verification to catch semantic formatting errors earlier.

---
### 修复

- **订阅节点** — 修复了从纯 Base64 的 Share-links 导入订阅时因校验顺序错误导致所有节点无法连接的问题。
- **配置校验** — 优化了远端配置格式的早期校验逻辑，能在应用前更准确地拦截格式错误。
