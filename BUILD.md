# 构建说明 (Build Guide)

## 项目概览

这是一个 Tauri v2 桌面应用,将「照片素材智能筛选系统」HTML 应用打包为原生安装包。

- **macOS**: 生成 `.dmg` 安装包(适配 Apple Silicon M 系列 + Intel)
- **Windows**: 生成 `.msi` / `.exe` 安装包

## 前置条件

### 通用
| 工具 | 版本 | 安装方式 |
|------|------|----------|
| Node.js | ≥ 18 | https://nodejs.org |
| Rust  | ≥ 1.77 | https://rustup.rs |

### macOS 额外
| 工具 | 说明 |
|------|------|
| Xcode Command Line Tools | `xcode-select --install` |

### Windows 额外
| 工具 | 说明 |
|------|------|
| Microsoft Visual Studio Build Tools | 需包含「C++ 生成工具」工作负载(https://visualstudio.microsoft.com/visual-cpp-build-tools/) |
| WebView2 | Windows 10 1809+ 已内置 |
| WiX Toolset (仅 .msi) | https://wixtoolset.org/ |

## 本地构建

```bash
# 1. 进入项目目录
cd photo-screener

# 2. 安装前端依赖
npm install

# 3. 构建 Tauri 应用 (自动执行 npm run build + cargo build)
npm run tauri build
```

构建产物位置:

| 平台 | 路径 |
|------|------|
| macOS | `src-tauri/target/release/bundle/dmg/照片素材筛选系统_1.0.0_x64.dmg` |
| Windows | `src-tauri/target/release/bundle/msi/照片素材筛选系统_1.0.0_x64.msi` |
| Windows(NSIS) | `src-tauri/target/release/bundle/nsis/照片素材筛选系统_1.0.0_x64-setup.exe` |

`npm run tauri build -- --target universal-apple-darwin` 可生成 Universal Binary(同时支持 Intel + Apple Silicon)。

## CI 自动构建

项目已配置 GitHub Actions 工作流(`.github/workflows/build.yml`)。

**使用方法**:
1. 在 GitHub 创建仓库
2. 将本项目源代码推送至仓库的 `main` 分支
3. CI 会自动在 Ubuntu / macOS / Windows 上并行构建
4. 构建产物作为 Artifact 可在 Actions 页面下载

## 开发

```bash
# 启动 Vite 开发服务器
npm run dev

# 启动 Tauri 开发模式 (自动启动 Vite 并打开原生窗口)
npm run tauri dev
```

## 技术栈

- **前端**: Vite + 纯 JavaScript(零框架,零外部运行时依赖)
- **桌面壳**: Tauri v2 + Rust
- **插件**: tauri-plugin-dialog(文件对话框) + tauri-plugin-fs(文件系统)
- **构建**: GitHub Actions(跨平台 CI)

## 架构说明

应用在桌面模式下(作为 Tauri 运行时)使用 `@tauri-apps/plugin-dialog` 和 `@tauri-apps/plugin-fs` 进行文件选择与写入;在浏览器中(直接打开 HTML)则使用 Web File System Access API 或 ZIP 兜底。两种模式共享同一份 HTML/JS/CSS,通过 `window.__TAURI_ACTIVE` 自动切换。
