import theme from '../theme'

export default () => (
  <a href='/'>
    <em>The</em> Woodland Kitchen
    <style jsx>{`
      a {
        display: block;
        font-family: "${theme.fonts.serif}";
        font-weight: 400;
        text-transform: uppercase;
        font-size: 15vw;
        padding: 1.5vw 1vw;
        text-align: center;
        text-decoration: none;
        color: #fff;
        background-color: #010101;
      }
      a:hover {
        color: #fff;
      }
      em {
        /* We want WOODLAND KITCHEN to be as large as possible at small sizes.
         * Forcing 'the' to its own line gives more space to expand into.
        */
        font-size: 6vw;
        text-transform: lowercase;
        display: block;
      }
      @media(${theme.mediumScreen}) {
        a {
          font-size: 8vw;
        }
        em {
          /* Put "the" from "the WOODLAND KITCHEN" on the same line. This
           * makes the logo text a bit smaller at large sizes.
           */
          display: inline;
        }
    `}</style>
  </a>
)
