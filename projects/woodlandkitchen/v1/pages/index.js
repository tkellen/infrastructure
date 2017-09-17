import Layout from '../layouts/main'
import Header from '../components/header'
import Footer from '../components/footer'
import CallToAction from '../components/call-to-action'
import Lead from '../components/lead'
import ActionButton from '../components/action-button'
import Img from '../components/img'
import GroupedItems from '../components/grouped-items'
import Panel from '../components/panel'
import EmailSignup from '../components/email-signup'

import { skills, journals } from '../data'

export default () => (
  <Layout title='The Woodland Kitchen'>
    <Header />
    <CallToAction>
      <Lead type='hero' tagline='Feed your adventure.' subheading='Join a growing community of food-lovers and get access to a free library of cooking guides and goodies.'>
        <ActionButton text='Sign me up!' />
      </Lead>
      <Img id='36148358284' />
    </CallToAction>
    <Lead type='skills' tagline="Let's get started!" subheading='What do you want to do?' />
    <GroupedItems items={skills} groupCount={3} Component={Panel} />
    <Lead type='journal' tagline="What's cooking?" subheading='Browse the latest entries from my cooking journal.' />
    <GroupedItems items={journals} groupCount={3} Component={Panel} />
    <EmailSignup />
    <Footer />
  </Layout>
)
