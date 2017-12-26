import {tmpl} from '../lib/html';

export default function (props) {
  return tmpl`<img
    src="${props.sources.main}"
    title="${props.title}"
    alt="${props.title}"
    srcset="
      ${props.sources.large}
      ${props.sources.medium}
      ${props.sources.small}
    "
  >`;
}
