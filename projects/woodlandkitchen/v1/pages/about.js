import { Component } from 'react'

import Layout from '../layouts/main'
import Header from '../components/header'
import Lead from '../components/lead'
import Img from '../components/img'
import Video from '../components/video'
import EmailSignup from '../components/email-signup'
import Footer from '../components/footer'

export default class extends Component {

  render() {
    return (
      <Layout title="About">
        <Header/>
        <Lead tagline="Welcome to the sweet spot where food meets adventure."/>
        <Video src="https://player.vimeo.com/video/219459147?title=0&byline=0&portrait=0"/>
        <Lead tagline="About Me" subheading="I'm Tara! I’m passionate about helping people become more intuitive, adventurous, and skilled with food and flavors, whether their kitchens are indoors or out."/>
        <Img id="30243628340"/>
        <EmailSignup/>
        <Footer/>
      </Layout>
    )
  }
}
