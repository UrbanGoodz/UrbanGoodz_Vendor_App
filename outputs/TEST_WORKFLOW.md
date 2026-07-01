# Urban Goodz Fast Test Workflow

## 1. Make Code Edits

Use Codex for code edits only.

Do not commit, push, or deploy during the edit/review loop.

## 2. Start Local Preview

From the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\test-preview.ps1
```

The script runs:

```powershell
flutter pub get
flutter build web --release --base-href /
```

If the build fails, it runs `flutter clean` once, then retries the build.

After a successful build, it starts:

```powershell
python -m http.server 8080
```

from:

```text
build\web
```

Preview URL:

```text
http://localhost:8080
```

## 3. Visual Review

Use Antigravity/browser screenshots for visual review.

Check the local preview before preparing any deployment ZIP.

## 4. Deployment Rule

Only deploy the ZIP to cPanel after local preview is approved.

Do not commit.
Do not push.
Do not deploy.
