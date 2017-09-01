import { Component } from 'react'
import Link from 'next/link'

import HamburgerButton from './hamburger-button'

import theme from '../theme'

export default class extends Component {

  constructor() {
    super()
    this.state = {
      forceShow: false
    };
    this.showHide = this.showHide.bind(this)
  }

  showHide(state) {
    this.setState({forceShow:state})
  }

  render() {
    const forceShowClass = this.state.forceShow ? 'show' : '';
    return (
      <nav role="navigation" aria-label="primary navigation">
        <style jsx>{`
          nav {
            position: relative;
            text-align: center;
            cursor: pointer;
            font-size: 6vw;
            border-top: 1px solid ${theme.colors.border};
            /* stop giant bright click effect on mobile taps */
            -webkit-tap-highlight-color: transparent;
            background-color: ${theme.colors.navBackground};
            font-family: "${theme.fonts.sansSerif}";
            font-weight: 200;
          }
          ul {
            display: none; /* Hide nav at small screen sizes until opened. */
            list-style: none;
            padding: 0;
            margin: 0;
          }
          .show {
            display: block !important;
          }
          a {
            padding: 1vw;
            display: block;
            border-bottom: 1px solid ${theme.colors.border};
            color: #fff;
            text-decoration: none;
          }
          @media(${theme.mediumScreen}) {
            nav {
              font-size: 1.25em;
            }
            ul { /* always show nav at large sizes */
              display: block;
              border-bottom: 1px solid ${theme.colors.border};
            }
            li {
              display: inline-block;
            }
            a {
              padding: 1vw;
              border: none;
            }
          }
        `}</style>
        <HamburgerButton clickHandler={this.showHide}/>
        <ul className={forceShowClass}>
          <li><Link href="/about"><a>about</a></Link></li>
          <li><Link href="/journal"><a>journal</a></Link></li>
          <li><Link href="/recipes"><a>recipes</a></Link></li>
          <li><Link href="/free-cooking-guides"><a>free cooking guides</a></Link></li>
          <li><Link href="/workshops"><a>workshops</a></Link></li>
          <li><Link href="/books"><a>books</a></Link></li>
        </ul>
      </nav>
    )
  }

}
