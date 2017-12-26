import {readdirSync} from 'fs';
import {basename as base, join as joinPath} from 'path';

import config from '../config';
import {vdom} from './lib/html';
import http from './services/http';

import journal from './wireframes/journal';
import journal_entry from './wireframes/journal_entry';
import journal_entry_in_scope from './wireframes/journal_entry_in_scope';
import journal_entry_with_all_scopes from './wireframes/journal_entry_with_all_scopes';
import journal_entry_with_one_scope from './wireframes/journal_entry_with_one_scope';
import journal_list_month from './wireframes/journal_list_month';
import journal_list_year from './wireframes/journal_list_year';

const wireframes = {
  journal: journal,
  journal_entry: journal_entry,
  journal_entry_in_scope: journal_entry_in_scope,
  journal_entry_with_all_scopes: journal_entry_with_all_scopes,
  journal_entry_with_one_scope: journal_entry_with_one_scope,
  journal_list_month: journal_list_month,
  journal_list_year: journal_list_year
};
const routes = Object.keys(wireframes);

routes.forEach((route) => {
  const tree = wireframes[route];
  http.get(`/${route}`, (req, res) => {
    res.send(vdom(tree).toString());
  })
});

http.get('/', function (req, res) {
  const links = routes.map(f => `<a href=/${f}>${f}</a>`)
  res.send(links.join('<br>'));
});

http.use((err, req, res, next) => {
  console.error(err.stack);
  if (config.DEBUG) {
    res.send(err.stack);
  }
  res.status(500);
});

console.log(
  'Server listening on %s:%d',
  config.HTTP_HOST,
  config.HTTP_PORT
);

http.listen(config.HTTP_PORT);
