export default (props) => (
  <div>
    <style jsx>{`
      div {
        position: relative;
        padding-bottom: 56.5%; /* enforce 16/9 ratio */
        height: 0;
        margin: 0 auto;
      }
      iframe {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        border: none;
      }
    `}</style>
    <iframe src={props.src} frameBorder="0" allowFullScreen></iframe>
  </div>
)
