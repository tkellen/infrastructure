import theme from '../theme'

export default (props) => (
  <div className={props.type}>
    <style jsx>{`
      div {
        padding: 10vh 10vw;
        z-index: 1;
        width: 100%;
        text-align: center;
        background-color: #111;
        box-sizing: border-box;
        font-family: "${theme.fonts.serif}";
        color: #fff;
      }
      * + * {
        margin-top: 5vw;
      }
      h1 {
        font-size: 8vw;
        box-sizing: border-box;
        font-family: "${theme.fonts.serif}";
        font-weight: 200;
        margin: 0;
      }
      p {
        font-family: "${theme.fonts.sansSerif}";
        font-size: 6vw;
        font-style: italic;
        font-weight: 200;
      }
      @media(${theme.mediumScreen}) {
        div {
          padding-left: 15vw;
          padding-right: 15vw;
        }
        * + * {
          margin-top: 3vw;
        }
        h1 {
          font-size: 5vw;
        }
        p {
          font-size: 2.5vw;
        }
        .hero {
          background-color: transparent; /* there will be an image */
          padding-top: 5vw;
          padding-bottom: 5vw;
          position: absolute;
          top: 0;
          text-align: left;
        }
        .hero h1 {
          text-shadow:
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy};
        }
        .hero p {
          text-shadow:
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy},
            0 0 1vw ${theme.colors.hazy};
          width: 50%;
        }
        .hero button {
          margin-top: 3vw;
          font-size: 3vw;
        }
      }
    `}</style>
    <h1>{props.tagline}</h1>
    {props.subheading && <p>{props.subheading}</p>}
    {props.children}
  </div>
)
