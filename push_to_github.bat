@echo off
chcp 65001 >nul
echo ============================================
echo  照片素材智能筛选系统 - 推送到 GitHub
echo ============================================
echo.
echo 步骤 1: 在浏览器中创建 GitHub 仓库
echo ----------------------------------------
echo  1. 打开 https://github.com/new
echo  2. Repository name: photo-screener
echo  3. 选 "Public"
echo  4. 不要勾选 "Add a README" (我们已经有了)
echo  5. 点 "Create repository"
echo.
echo 创建完成后, 复制仓库的 URL, 形如:
echo   https://github.com/你的用户名/photo-screener.git
echo.
echo ============================================
echo 步骤 2: 输入仓库 URL
echo ============================================
set /p REPO_URL="粘贴你的仓库 URL (回车确认): "

if "%REPO_URL%"=="" (
    echo 未输入 URL, 退出
    pause
    exit /b 1
)

echo.
echo ============================================
echo 步骤 3: 推送代码
echo ============================================
echo 仓库: %REPO_URL%
echo.

git remote remove origin 2>nul
git remote add origin "%REPO_URL%"
echo 已添加远程 origin
echo.

echo 正在推送代码到 main 分支...
git branch -M main
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo  推送成功!
    echo ============================================
    echo.
    echo GitHub Actions 正在自动编译两个安装包...
    echo.
    echo 1. 打开 https://github.com/ 登录你的账号
    echo 2. 进入 photo-screener 仓库
    echo 3. 点顶部 "Actions" 标签
    echo 4. 等 10-15 分钟(首次编译较慢)
    echo 5. 进入 build 任务,在底部 "Artifacts" 下载:
    echo    - photo-screener-macos (含 .dmg)
    echo    - photo-screener-windows (含 .exe)
    echo.
) else (
    echo.
    echo 推送失败, 请检查:
    echo   1. URL 是否正确
    echo   2. 网络是否正常
    echo   3. 是否需要配置 SSH key 或 Personal Access Token
    echo.
    echo 如果是认证问题, 可使用 Personal Access Token:
    echo   https://github.com/settings/tokens
    echo   然后用 https://用户名:token@github.com/用户名/photo-screener.git 格式的 URL
)

pause
