import arrayChunk from '../utils/array-chunk';

import theme from '../theme';

export default (props) => {
  const { Component, groupCount, items } = props
  const groups = arrayChunk(groupCount, items)
  return (
    <div>
      <style jsx>{`
        @media(${theme.mediumScreen}) {
          section {
            display: flex;
          }
        }
      `}</style>
      {groups.map(group =>
        <section key={group.key}>
          {group.items.map(item => <Component {...item}/> )}
        </section>
      )}
    </div>
  )
}
