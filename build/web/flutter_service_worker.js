'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "0d547609e42aaf82ee2d33ee819dd5fe",
"assets/AssetManifest.bin.json": "df355f508d095ea64f2757549d2a044b",
"assets/AssetManifest.json": "97e6cb2a27b0f483ed7da5aa400d571f",
"assets/assets/images/banner1.jpg": "0c345d83170e8d3d06b0788c31d43013",
"assets/assets/images/banner2.jpg": "77e5f886a99e20f4f5d0a19b478778f4",
"assets/assets/images/banner3.jpg": "a9f5cfe07f935f6b351aa43b732ec930",
"assets/assets/images/gal1.jpg": "06f9a54019c8525658ec8934edc823ac",
"assets/assets/images/gal2.jpg": "26f850f95f63b64db727d12dc686acc1",
"assets/assets/images/gal3.jpg": "dadab291ce357db63fd3f2bc6074afcc",
"assets/assets/images/gal4.jpg": "a9f5cfe07f935f6b351aa43b732ec930",
"assets/assets/images/gal5.jpg": "77e5f886a99e20f4f5d0a19b478778f4",
"assets/assets/images/gal6.jpg": "07c1fcd18d2eba24d92522a8bc78d077",
"assets/assets/images/gal7.jpg": "0c345d83170e8d3d06b0788c31d43013",
"assets/assets/images/gal8.jpg": "0924bd5c2273864713b62d6f194ec86f",
"assets/assets/images/murgabhai.png": "2819bc43142b9c48e7ee505eec814b4d",
"assets/assets/images/poultrylogo.png": "51c88f9bea22dd7a9b357808558c9608",
"assets/assets/images/pro1.png": "3dd5d4cebc50c28360845588c79f46c1",
"assets/assets/images/pro2.png": "a2c276a9668e294674745d782f62d5c6",
"assets/assets/images/pro3.png": "4d9bce4af6f003bbeaf9c079259a8aee",
"assets/assets/images/pro4.png": "8b9eeee2ae7ece6f4dcd8d2ce9f77ff6",
"assets/assets/images/pro5.png": "3c16efdf4bd6ec7a87accf3431486724",
"assets/assets/images/pro6.png": "46884c6c8bf00ea5e84e6dc304e75c93",
"assets/assets/images/pro7.png": "4d9bce4af6f003bbeaf9c079259a8aee",
"assets/assets/images/ser1.png": "cf599f9df6298083c287bd7aca9f3aac",
"assets/assets/images/ser2.png": "02f5c0930f4fcd61422e2d0a4991e8bb",
"assets/assets/images/ser3.png": "679fb6bd9e395d18810104e258667538",
"assets/assets/images/ser4.png": "cdd6c0a295310b15754bee9a3b1ec187",
"assets/assets/images/ser5.png": "4bb4776f522b4d0cfb16615d8b15e87c",
"assets/assets/images/ser6.png": "00167ab5e0b903b01fb71298b0a7ed76",
"assets/assets/images/team1.jpg": "97126c3ef52036447571835b55fcafdd",
"assets/assets/images/team2.jpg": "030b73260e98377ccc5cce5a56b44178",
"assets/assets/images/team3.jpg": "674c904b8476ea86cc0ea0a3e42349f0",
"assets/assets/images/team4.jpg": "5f07d839bef03ca2c8c9113bf422069b",
"assets/FontManifest.json": "199fab72df73d2caf8789967942a2004",
"assets/fonts/MaterialIcons-Regular.otf": "3d806cf2dfc8f7f6236792b39cfcd81c",
"assets/NOTICES": "ba1643160fcdcddbf77d3e97f0887e35",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/packages/iconly/fonts/IconlyBold.ttf": "128714c5bf5b14842f735ecf709ca0d1",
"assets/packages/iconly/fonts/IconlyBroken.ttf": "6fbd555150d4f77e91c345e125c4ecb6",
"assets/packages/iconly/fonts/IconlyLight.ttf": "5f376412227e6f8450fe79aec1c2a800",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "aff24dfc144b2fe7426e7988837ec33e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c40456128be1dce88c85dc9ee41ff24a",
"/": "c40456128be1dce88c85dc9ee41ff24a",
"main.dart.js": "943acec91bb4f4a2f1324c339889d21f",
"manifest.json": "2801d7133156731ebe28171f63a2b24c",
"version.json": "ee72c5721bf6790d86056b7bf8d36110"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
