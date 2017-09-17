import Link from 'next/link'

import Layout from '../layouts/base'
import Notice from '../components/notice'
import Logo from '../components/logo'
import Nav from '../components/nav'
import CallToAction from '../components/call-to-action'
import Lead from '../components/lead'
import ActionButton from '../components/action-button'
import Img from '../components/img'
import GroupedItems from '../components/grouped-items'
import Panel from '../components/panel'
import EmailSignup from '../components/email-signup'
import Footer from '../components/footer'
import SocialLinks from '../components/social-links'

import { skills, journals } from '../data'

export default () => (
  <Layout title='The Woodland Kitchen'>
    <header>
      <Notice url='https://bikecampcook.com/' body='Click here to learn the art of camp cooking!' />
      <Logo />
      <Nav />
    </header>
    <CallToAction>
      <Lead type='hero' tagline='Feed your adventure.' subheading='A description of what feed your adventure means.'>
        <Link href='/join'><a><ActionButton text='People will activate this when they are interested' /></a></Link>
      </Lead>
      <Img id='36148358284' />
    </CallToAction>
    <Lead type='skills' tagline="Let's get started!" subheading='What do you want to do?' />
    <GroupedItems items={skills} groupCount={3} Component={Panel} />
    <Lead type='journal' tagline="What's cooking?" subheading='Browse the latest entries from my cooking journal.' />
    <GroupedItems items={journals} groupCount={3} Component={Panel} />
    <EmailSignup />
    <Footer>
      <SocialLinks />
    </Footer>
  </Layout>
)
