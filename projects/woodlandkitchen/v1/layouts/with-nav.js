import Base from './base'
import Logo from '../components/logo'
import Nav from '../components/nav'
import Footer from '../components/footer'
import SocialLinks from '../components/social-links'

export default (props) => (
  <Base {...props}>
    <header>
      <Logo/>
      <Nav/>
    </header>
    {props.children}
    <Footer>
      <SocialLinks />
    </Footer>
  </Base>
)
