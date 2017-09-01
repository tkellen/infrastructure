import render from 'react-dom'

import theme from '../theme'

export default (props) => (
  <section className="two-up">
    {/* This needs to be global until I can render markdown as react components */}
    <style jsx global>{`
      .two-up {
        padding: 2vw;
      }
      .two-up div {
        padding: 5vw;
        display: block;
        font-size: 5vw;
      }
      .two-up div * + * {
        margin-top: 2vw;
      }
      .two-up h2 {
        font-size: 7vw;
      }
      .two-up h3 {
        font-size: 6vw;
      }
      @media(${theme.mediumScreen}) {
        .two-up {
          display: flex;
          font-size: 2vw;
        }
        .two-up div {
          flex: 50%;
          font-size: 3vw;
        }
        .two-up h2 {
          font-size: 5vw;
        }
        .two-up h3 {
          font-size: 3vw;
        }
    `}</style>
    <div dangerouslySetInnerHTML={{ __html:props.one }}></div>
    <div dangerouslySetInnerHTML={{ __html:props.two }}></div>
  </section>
)
