import Base from './layout'
import Logo from '../components/logo'
import Nav from '../components/nav'
import Footer fro '../components/footer'

export default (props) => (
  <Base {...props}>
    <header>
      <Logo/>
    </header>
    {props.children}
    <Footer />
  </Base>
)
