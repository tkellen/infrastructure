import Layout from '../layouts/with-nav'
import Lead from '../components/lead'
import Img from '../components/img'
import Video from '../components/video'
import EmailSignup from '../components/email-signup'

export default () => (
  <Layout title='About'>
    <Lead tagline='Welcome to the sweet spot where food meets adventure.' />
    <Video src='https://player.vimeo.com/video/219459147?title=0&byline=0&portrait=0' />
    <Lead tagline='About Me' subheading="I'm Tara! I’m passionate about helping people become more intuitive, adventurous, and skilled with food and flavors, whether their kitchens are indoors or out." />
    <Img id='30243628340' />
    <EmailSignup />
  </Layout>
)
