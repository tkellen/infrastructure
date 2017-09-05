import Layout from '../layouts/main'
import Header from '../components/header'
import Container from '../components/container'
import Img from '../components/img'
import Recipe from '../components/recipe'
import EmailSignup from '../components/email-signup'
import Footer from '../components/footer'

export default () => (
  <Layout title="Journal">
    <Header/>
    <Container
      title="Ottolenghi's Jerusalem Spice Cookies"
      img={<Img id="36797251436" style={{opacity:0.9}}/>}
    >
      <Recipe/>
    </Container>
    <EmailSignup/>
    <Footer/>
  </Layout>
)

//<Lead type="journal" tagline="What's cooking?" subheading="Browse the latest entries from my cooking journal."/>
//<GroupedItems items={journals} groupCount={3} Component={Panel}/>
