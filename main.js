pannellum.viewer('panorama-container', {
    "type": "equirectangular",
    "panorama": "assets/placeholder-pano.jpg",
    "autoLoad": true,           // Bypasses the "Click to Load" screen.
    "showControls": false,      // Removes zoom, fullscreen, and compass UI.
    "mouseZoom": false,         // Prevents accidental slide changes in PPT when scrolling.
    "keyboardZoom": false,      // Prevents hotkey interference.
    "disableKeyboardCtrl": true // Reserves arrow keys for PPT slide navigation.
});
