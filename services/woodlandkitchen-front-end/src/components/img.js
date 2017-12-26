import { imageHost, images } from '../data'

export default (props) => {
  // todo, look up images in database
  const image = images[props.id]
  const src = `${props.id}${image.type}`
  return (
    /* requiring a parent element is a limitation of styled-jsx, sadly
     * https://github.com/zeit/styled-jsx/issues/169
     * TOOD: should we have some kind of default height at varying
     * screen sizes so that slow loads can see a box where an image
     * should be.
     */
    <div>
      <style jsx>{`
        img {
          width: 100%;
          height: auto;
          transform: translate3d(0, 0, 0);
          display: block;
          background-color: #000;
        }
      `}</style>
      <img style={props.style} alt={image.title} src={`${imageHost}/img/320/${src}`} srcSet={`
        ${imageHost}/img/320/${src}} 320w,
        ${imageHost}/img/480/${src} 480w,
        ${imageHost}/img/640/${src} 640w,
        ${imageHost}/img/960/${src} 960w,
        ${imageHost}/img/1280/${src} 1280w,
        ${imageHost}/img/1920/${src} 1920w,
        ${imageHost}/img/2560/${src} 2560w`} />
    </div>
  )
}
