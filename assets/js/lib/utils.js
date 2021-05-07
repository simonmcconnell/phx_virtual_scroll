export function isEditableElement(element) {
  return (
    ["input", "textarea"].includes(element.tagName.toLowerCase()) ||
    element.contentEditable === "true"
  );
}

export function clamp(n, x, y) {
  return Math.min(Math.max(n, x), y);
}

export function getLineHeight(element) {
  const computedStyle = window.getComputedStyle(element);
  const lineHeight = parseInt(computedStyle.lineHeight, 10);

  if (Number.isNaN(lineHeight)) {
    const clone = element.cloneNode();
    clone.innerHTML = "<br>";
    element.appendChild(clone);
    const singleLineHeight = clone.clientHeight;
    clone.innerHTML = "<br><br>";
    const doubleLineHeight = clone.clientHeight;
    element.removeChild(clone);
    const lineHeight = doubleLineHeight - singleLineHeight;
    return lineHeight;
  } else {
    return lineHeight;
  }
}

export function selectElementContent(element) {
  const selection = window.getSelection();
  const range = document.createRange();
  range.selectNodeContents(element);
  selection.removeAllRanges();
  selection.addRange(range);
}

export function smoothlyScrollToElement(element) {
  const { height } = element.getBoundingClientRect();

  if (height < window.innerHeight) {
    element.scrollIntoView({ behavior: "smooth", block: "center" });
  } else {
    element.scrollIntoView({ behavior: "smooth", block: "start" });
  }
}

/**
 * Transforms a UTF8 string into base64 encoding.
 */
export function encodeBase64(string) {
  return btoa(unescape(encodeURIComponent(string)));
}

/**
 * Transforms base64 encoding into UTF8 string.
 */
export function decodeBase64(binary) {
  return decodeURIComponent(escape(atob(binary)));
}
