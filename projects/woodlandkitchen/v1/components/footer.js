import Img from './img'

import theme from '../theme'

export default (props) => (
  <footer>
    <style jsx>{`
      footer {
        position: relative;
        border-top: 1px solid ${theme.colors.border};
        font-size: 3em;
      }
      div {
        position: absolute;
        width: 100%;
        bottom: 7vw;
        text-align: center;
        z-index: 1;
      }
    `}</style>
    <div>
      {props.children}
    </div>
    <Img id='29883925391' />
  </footer>
)
