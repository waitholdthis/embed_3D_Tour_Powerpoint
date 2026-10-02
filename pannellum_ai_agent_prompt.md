# Project: Presentation-Optimized Pannellum 360 Viewer

## 1. Project Overview
**Objective:** Build a single-page HTML/JS application that renders a 360-degree equirectangular panorama using the Pannellum library. 
**Target Environment:** This web app will be embedded inside a Microsoft PowerPoint presentation via a Web Viewer Add-in. Therefore, the UI must be completely seamless, with no default controls, loading screens, or scroll-wheel zoom capabilities that might accidentally trigger a slide change.

## 2. Tech Stack & Dependencies
*   **HTML5 / CSS3 / Vanilla JavaScript**
*   **Pannellum Library:** Load via CDN to avoid local hosting complexities.
    *   CSS: `https://cdn.jsdelivr.net/npm/pannellum@2.5.6/build/pannellum.css`
    *   JS: `https://cdn.jsdelivr.net/npm/pannellum@2.5.6/build/pannellum.js`

## 3. File Structure
Please generate the following file structure:
```text
/project-root
  ├── index.html
  ├── style.css
  ├── main.js
  └── /assets
      └── placeholder-pano.jpg
```
*(Note to agent: Use any high-res equirectangular placeholder image for `placeholder-pano.jpg` during development).*

## 4. Specific Code Requirements

### A. HTML (`index.html`)
*   Create a standard HTML5 boilerplate.
*   Import the Pannellum CSS in the `<head>`.
*   Import the Pannellum JS script before the closing `</body>` tag.
*   Create a single `<div>` with the ID `panorama-container` that will hold the viewer.
*   Link to the custom `style.css` and `main.js` files.

### B. CSS (`style.css`)
*   **Zero Out Margins:** Apply a CSS reset to `html` and `body` (margin: 0; padding: 0; overflow: hidden;) to prevent any scrollbars.
*   **Fullscreen Container:** Style `#panorama-container` to have `width: 100vw;` and `height: 100vh;` so it fills the PowerPoint iframe entirely.
*   **Accessibility/Focus Outline:** Remove the default focus outline on the viewer so clicking and dragging doesn't create a blue ring around the iframe (`outline: none;`).

### C. JavaScript (`main.js`)
Initialize the Pannellum viewer with the following STRICT configuration object. These parameters are critical for the PowerPoint use case:

```javascript
pannellum.viewer('panorama-container', {
    "type": "equirectangular",
    "panorama": "assets/placeholder-pano.jpg",
    "autoLoad": true,         // CRITICAL: Bypasses the "Click to Load" screen.
    "showControls": false,    // CRITICAL: Removes zoom, fullscreen, and compass UI.
    "mouseZoom": false,       // CRITICAL: Prevents accidental slide changes in PPT when scrolling.
    "keyboardZoom": false,    // Prevents hotkey interference.
    "disableKeyboardCtrl": true // Prevents arrow keys from moving the panorama, reserving them for PPT slide navigation.
});
```

## 5. Acceptance Criteria
Before concluding the task, ensure the following criteria are met:
1.  **Immediate Render:** Upon loading `index.html`, the 3D panorama appears immediately without requiring a user click.
2.  **Clean UI:** There are no buttons, zoom sliders, or compass indicators visible on the screen.
3.  **Interaction:** The user can click and drag to pan around the 360 environment seamlessly.
4.  **No Zoom:** Scrolling the mouse wheel or trackpad does *not* zoom in or out of the image.
5.  **No Scrollbars:** The browser window has no horizontal or vertical scrollbars.

## 6. Deployment Notes for User
*Once the agent completes this project, you must host these files on a web server that supports HTTPS (e.g., GitHub Pages, Vercel, Netlify). PowerPoint Web Viewer add-ins require an `https://` protocol to embed web content successfully.*