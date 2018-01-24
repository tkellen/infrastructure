import {tmpl} from '../lib/html';

import topic from './topic';
import image from './image';

export default function (props) {
  return tmpl`
    <div class="synopsis">
      <a href="/journal/${props.slug}"><h1>${props.title}</h1></a>
      <a href="/journal/${props.slug}">${image(props.image)}</a>
      <p class="synopsis">
      There are times on this trip when I question my abilities.  Am I really capable of doing this?  What are we even doing here?  Why am I doing this?  What is the value of this?  These thoughts generally make a pronounced appearance when we are somewhere that feels like the middle of nowhere.
      </p>
      <div class="meta map">
        <a href="/map${props.slug}">map</a>
      </p>
      <div class="meta location">
        <a href="/location${props.slug}">location</a>
      </p>
      <div class="meta stats">
        <a href="/stats${props.slug}">stats</a>
      </p>
      <div class="meta location">
        <a href="/location${props.slug}">location</a>
      </p>
      <div class="meta photos">
        <a href="/photos${props.slug}">photos</a>
      </p>
      <div class="meta topic">
        <ul>
          ${props.topics.map((item) => {
            return tmpl`<li>${topic(item)}</li>`
          })}
        </ul>
      </p>
    </div>
  `;
}
