import theme from '../theme'

export default (props) => (
  <div>
    <style jsx>{`
      div {
        position: relative;
        font-weight: 200;
        border-top: 1px solid ${theme.colors.border};
        border-bottom: 1px solid ${theme.colors.border};
      }
      img {
        position: absolute;
        opacity: .75;
      }
    `}</style>
    {props.children}
  </div>
)
