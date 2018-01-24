import {tmpl} from '../lib/html';

export default function (props) {
  return tmpl`<a href="/topic/${props.slug}">${props.title}</a>`
}
