import Link from 'next/link'

import theme from '../theme'

export default (props) => (
  <div>
    <style jsx>{`
      div {
        background-color: ${theme.colors.action};
        color: #fff;
        text-align: center;
        border-bottom: .1vw solid ${theme.colors.border};
        font-weight: 400;
        display: block;
        padding: .5vw;
        font-size: 4vw;
        font-family: "${theme.fonts.sansSerif}";
      }
      div:hover {
        background-color: ${theme.colors.actionHighlight};
        font-weight: 600;
      }
      a {
        text-decoration: none;
        color: #fff;
        font-weight: 200;
      }
      @media(min-width: 768px) {
        div {
          font-size: 2vw;
          padding: .1vw;
        }
      }
    `}</style>
    <Link href={props.url}><a>{props.body}</a></Link>
  </div>
)
