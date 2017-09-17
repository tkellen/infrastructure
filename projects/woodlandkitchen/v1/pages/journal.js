import Layout from '../layouts/with-nav'
import Notice from '../components/notice'
import Logo from '../components/logo'
import Nav from '../components/nav'
import Container from '../components/container'
import Img from '../components/img'
import Entry from '../components/entry'
import EmailSignup from '../components/email-signup'

export default () => (
  <Layout title='Journal'>
    <Container
      title="Ottolenghi's Jerusalem Spice Cookies"
      img={<Img id='36797251436' style={{opacity: 0.9}} />}
    >
      <Entry />
    </Container>
    <EmailSignup />
  </Layout>
)

// <Lead type="journal" tagline="What's cooking?" subheading="Browse the latest entries from my cooking journal."/>
// <GroupedItems items={journals} groupCount={3} Component={Panel}/>
