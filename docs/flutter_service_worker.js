'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "4411f1c7a522fdbbf99aa74bb8047a89",
"/": "4411f1c7a522fdbbf99aa74bb8047a89",
"main.dart.js.deps": "d9b57c9d9fb88776273a00ce056e2cac",
"main.dart.js": "b242db430a87d38019c2d0569b5406de",
"logo.png": "89246628b94e469988146d59733164a5",
"before_one_min_jp.mp3": "afe6506ef7e950b194be100d15e09a08",
"before_one_min.mp3": "0bff7455b302a835f707a401942ff117",
"countdown_hk.mp3": "6c89087143f93d78e3e57e83de99d9f1",
"assets/LICENSE": "a7402085105f2f9af9f52fa9f5f1e29f",
"assets/AssetManifest.json": "49829652119f183b4a244d9e190228ef",
"assets/FontManifest.json": "cd5d2c8260d1c8497ae34010dc00cfc2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/BreeSerif-Regular.ttf": "14aaff013398c35430cc935d1e4dcd99",
"assets/assets/logo.png": "89246628b94e469988146d59733164a5",
"assets/assets/bee.mp3": "49927dd1a5160dcd5f057e90aa61aae0",
"assets/assets/start_end.mp3": "6ac2f6809cf9d8b9b638f8edc69480a0"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
