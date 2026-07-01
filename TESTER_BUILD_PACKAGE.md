# Urban Goodz Tester Build Package Guidelines

## Status
- **Ready**: Web bootstrap release assets compiled. `.htaccess` deep routing backups and `tester-guide.html` guide are copied into the release package.
- **Blocked**: Docker deployment pipelines or automated remote server sync (requires manual zip extract).

---

## 1. Local Rebuild Commands
To generate a fresh tester bundle locally, run these commands in sequence:

```powershell
# Compile production release build
flutter build web --release --base-href /

# Copy configuration extras into release folder
Copy-Item ".htaccess.backup" -Destination "build\web\.htaccess" -Force
Copy-Item "tester-guide.html.backup" -Destination "build\web\tester-guide.html" -Force

# Compress package
Compress-Archive -Path "build\web\*" -DestinationPath "outputs\urban-goodz-tester-web-build.zip" -Force
```

---

## 2. Server Extract Instructions
1. Upload the zip `outputs\urban-goodz-tester-web-build.zip` to `/home/urbakkej/test.urbangoodzdelivery.com` via cPanel File Manager or SFTP.
2. Delete previous files in that folder to avoid caching mismatch (except subfolders like `assets` if assets are uploaded separately, though they are inside the zip).
3. Extract the ZIP directly into the directory root.
4. Verify that the `.htaccess` file is present in cPanel (make sure hidden files are visible in File Manager settings).
