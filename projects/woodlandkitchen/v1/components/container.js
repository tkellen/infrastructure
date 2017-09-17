import theme from '../theme'

export default (props) => (
  <div>
    <style jsx>{`
      main {
        box-sizing: border-box;
        padding: 7vw;
        font-family: "${theme.fonts.sansSerif}";
        font-weight: 200;
        color: ${theme.colors.text};
        background: #111;
        font-size: 24px;
        line-height: 1.5em;
      }
      h1 {
        margin: 0;
        font-family: "${theme.fonts.serif}";
        font-weight: 200;
        box-sizing: border-box;
        padding: 10vw 5vw;
        font-size: 4em;
        z-index: 1;
        width: 100%;
        text-align: center;
        color: ${theme.colors.text};
        text-shadow:
          0 0 1vw ${theme.colors.hazy},
          0 0 1vw ${theme.colors.hazy},
          0 0 1vw ${theme.colors.hazy};
      }
      @media(${theme.mediumScreen}) {
        main {
          position: relative;
          font-size: 1.25em;
          padding: 5vw 5vw;
          z-index: 1;
          border: 1px solid #000;
          margin: 10vw 5vw;
          top: -18vw;
        }
        h1 {
          position: absolute;
          font-size: 3em;
        }
      }
      @media(${theme.largeScreen}) {
        main {
          font-size: 1em;
          margin: 10vw;
        }
      }
    `}</style>
    <h1>{props.title}</h1>
    {props.img}
    <main>
      {props.children}
    </main>
  </div>
)
