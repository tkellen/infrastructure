import {tmpl} from '../lib/html';

import layout from '../components/layout';
import entryBlock from '../components/entry_block';

export default layout({
  body: entryBlock({
    title: 'The Universe Provides',
    created_at: new Date(2010, 3, 22),
    slug: '/2010/04/the-universe-provides',
    image: {
      title: 'Knitter\'s Hands',
      sources: {
        main: 'http://img0.goingslowly.com/photos/small/4546051926.jpg',
        large: 'http://img0.goingslowly.com/photos/normal/4546051926.jpg',
        medium: 'http://img0.goingslowly.com/photos/medium/4546051926.jpg',
        small: 'http://img0.goingslowly.com/photos/small/4546051926.jpg'
      }
    },
    topics: [
      {
        title: 'Favorite Days',
        slug: 'favorite-days',
      },
      {
        title: 'Worst Moments',
        slug: 'worst-moments'
      },
      {
        title: 'Romania',
        slug: 'romania'
      }
    ]
  })
});
