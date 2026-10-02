const SETTING_KEY = 'url';
const DEFAULT_URL = 'https://waitholdthis.github.io/embed_3D_Tour_Powerpoint/';

const setup = document.getElementById('setup');
const input = document.getElementById('url');
const error = document.getElementById('error');
const frame = document.getElementById('frame');
const editButton = document.getElementById('edit');

let isEditView = true;

function normalizeUrl(raw) {
    let value = raw.trim();
    if (!value) return null;
    if (!/^[a-z]+:\/\//i.test(value)) value = 'https://' + value;
    try {
        const url = new URL(value);
        // http pages are blocked inside the https add-in frame (mixed content)
        return url.protocol === 'https:' ? url.href : null;
    } catch {
        return null;
    }
}

function showPage(url) {
    if (frame.src !== url) frame.src = url;
    setup.hidden = true;
    frame.hidden = false;
    editButton.hidden = !isEditView;
}

function showSetup(prefill) {
    input.value = prefill || DEFAULT_URL;
    error.textContent = '';
    frame.hidden = true;
    editButton.hidden = true;
    setup.hidden = false;
    input.focus();
    input.select();
}

function savedUrl() {
    return Office.context.document.settings.get(SETTING_KEY);
}

setup.addEventListener('submit', (event) => {
    event.preventDefault();
    const url = normalizeUrl(input.value);
    if (!url) {
        error.textContent = 'Enter a valid https:// address.';
        return;
    }
    const settings = Office.context.document.settings;
    settings.set(SETTING_KEY, url);
    settings.saveAsync();
    showPage(url);
});

editButton.addEventListener('click', () => showSetup(savedUrl()));

function applyView(view) {
    isEditView = view === 'edit';
    if (!frame.hidden) editButton.hidden = !isEditView;
    // Never leave the setup form on screen during a slideshow
    if (!isEditView && !setup.hidden && savedUrl()) showPage(savedUrl());
}

Office.onReady(() => {
    const url = savedUrl();
    if (url) showPage(url);
    else showSetup();

    const doc = Office.context.document;
    if (doc.getActiveViewAsync) {
        doc.getActiveViewAsync((result) => {
            if (result.status === Office.AsyncResultStatus.Succeeded) applyView(result.value);
        });
        doc.addHandlerAsync(Office.EventType.ActiveViewChanged, (args) => applyView(args.activeView));
    }
});
