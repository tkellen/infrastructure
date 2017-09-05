import { Component } from 'react'
import Head from 'next/head'

import asyncFonts from '../utils/async-fonts'
import analytics from '../utils/analytics'

import theme from '../theme';

class Layout extends Component {
  componentDidMount() {
    asyncFonts(theme.webfonts)
  }

  render() {
    const { title } = this.props;
    return (
      <div>
        <Head>
          <title>{title} | {theme.title}</title>
          <meta charSet="utf-8"/>
          <meta name="viewport" content="initial-scale=1.0, width=device-width"/>
          <style dangerouslySetInnerHTML={{__html: `
            * {
              -webkit-font-smoothing: antialiased;
               -webkit-font-smoothing: subpixel-antialiased;
            }
            html {
              background-color: ${theme.colors.background};
              font-size: 2vw;
            }
            body {
              margin: 0;
              min-width: 320px;
            }
          `}}/>
        </Head>
        {this.props.children}
      </div>
    )
  }
}

export default analytics(Layout)
