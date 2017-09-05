import theme from '../theme';

export default (props) => (
  <button>
    <style jsx>{`
      button {
        background-color: ${theme.colors.action};
        border: .1vw solid ${theme.colors.border};
        border-radius: .5vw;
        padding: 2vw 3vw;
        cursor: pointer;
        color: #fff;
        font-weight: 400;
        font-family: "${theme.fonts.serif}";
        outline: none;
        font-size: 5vw;
      }
      button:focus, button:hover {
        box-shadow: 0 0 2vw 0 ${theme.colors.hazy};
      }
      button:active {
        position: relative;
        background-color: ${theme.colors.actionHighlight};
        box-shadow: none;
        top: 1px;
      }
      button:hover {
        background-color: ${theme.colors.actionHighlight};
      }
      @media(${theme.mediumScreen}) {
        /* Bump buttons and inputs down a bit, we think they are overwelmingly
         * large without this.
         */
        button {
          font-size: 2vw;
          padding: 1vw 1.5vw;
        }
      }
    `}</style>
    {props.text}
  </button>
)
