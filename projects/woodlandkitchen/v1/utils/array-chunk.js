export default function (size, arr) {
  return arr
    .map((item, idx) => idx % size === 0 && arr.slice(idx, idx + size))
    .filter(item => item)
    .map(items => {
      return {
        items: items,
        key: items.map(item => item.key).join('')
      }
    })
}
