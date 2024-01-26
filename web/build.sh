flutter build web --release --base-href=/web/ --web-renderer html
rm -rf ../server/public/web
cp -r build/web ../server/public
