import Link from 'next/link'

import Img from './img'

import theme from '../theme'

export default (props) => (
  <div className={props.type}>
    <style jsx>{`
      div {
        position: relative;
      }
      h3 {
        margin: 0;
        padding: 0;
        font-weight: 200;
        font-family: "${theme.fonts.serif}";
        text-transform: lowercase;
      }
      a {
        position: absolute;
        z-index: 1;
        text-align: center;
        width: 100%;
        height: 100%;
        cursor: pointer;
        color: #fff;
        text-decoration: none;
      }
      a:hover {
        color: #336627;
      }
      p {
        color: #fff;
        position: absolute;
        font-family: "${theme.fonts.sansSerif}";
        width: 100%;
        bottom: 0;
        margin: 0;
        text-align: center;
        background-color: ${theme.colors.hazy};
        border-top: 2px solid ${theme.colors.border};
        font-size: 7vw;
        font-weight: 200;
        padding: 4vw;
        box-sizing: border-box;
      }
      /* todo find a better way to break this out */
      .skills a {
        padding-top: 25%;
        font-size: 20vw;
        opacity: .9;
        text-shadow:
          0 0 1vw ${theme.colors.hazy},
          0 0 1vw ${theme.colors.hazy},
          0 0 1vw ${theme.colors.hazy};
      }
      .skills a:hover {
        opacity: 1;
        color: #fff !important;
      }
      @media(${theme.mediumScreen}) {
        div {
          flex: 1 1 auto;
          border-right: 2px solid ${theme.colors.border};
        }
        div:last-child {
          margin-right: 0;
          border-right: none;
        }
        p {
          font-size: 2.5vw;
          padding: 1vw 1.5vw;
        }
        /* Bump down font size considerably because panel are displayed
         * in multiple columns at large screen sizes.
         */
        .skills a {
          font-size: 5vw;
        }
      }
    `}</style>
    <Link href={props.link}><a><h3>{props.title}</h3></a></Link>
    <Img id={props.img} />
    <p>{props.description}</p>
  </div>
)
