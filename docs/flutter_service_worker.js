'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "fbcc824b6ced05e85ecbee5df111ba9e",
"/main.dart.js.deps": "d9b57c9d9fb88776273a00ce056e2cac",
"/main.dart.js": "4f8baa5e7da5c8dd0a102ced9f19c475",
"/logo.png": "89246628b94e469988146d59733164a5",
"/assets/LICENSE": "e6ebb448a077395ec0b50d82ce1dc8ba",
"/assets/AssetManifest.json": "8a4c4b77dc1bfb1891d7fac0ec2fd3c4",
"/assets/FontManifest.json": "cd5d2c8260d1c8497ae34010dc00cfc2",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/assets/BreeSerif-Regular.ttf": "14aaff013398c35430cc935d1e4dcd99",
"/assets/assets/logo.png": "89246628b94e469988146d59733164a5"
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
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
