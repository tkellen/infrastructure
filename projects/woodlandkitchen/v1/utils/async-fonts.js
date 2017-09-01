const FontFaceObserver = require('fontfaceobserver')

function toUrl(font) {
  const styles = font.styles.map(style => `${style.weight}${style.style}`)
  return `${encodeURI(font.family)}:${styles.join(',')}`
}

export default (fonts) => {
  const query = fonts.map(toUrl).join('|');
  const link = document.createElement('link')
  link.href = `https://fonts.googleapis.com/css?family=${query}`
  link.rel = 'stylesheet'
  document.head.appendChild(link)
  const loadAll = fonts.map(font => font.styles.map(style =>
    new FontFaceObserver(font.family, style).load()
  ))
  return Promise.all([].concat([], loadAll)).then(() => {
    document.documentElement.className += 'fonts-loaded';
  });
}
