import {tmpl} from '../lib/html';

export default function (props) {
  return tmpl`
    <html>
    <head>
      <title></title>
      <meta charset="utf-8">
    </head>
    <body>
    ${props.body}
    </body>
    </html>
  `;
}
