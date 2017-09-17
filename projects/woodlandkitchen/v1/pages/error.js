import Layout from '../layouts/with-nav'
import Lead from '../components/lead'

export default () => (
  <Layout title='Error'>
    <Lead
      tagline="Oh no!"
      subheading="Something went wrong that we don't know how to recover from. Can you please try again, or let us know what happened?"
    />
    <Footer>
      <SocialLinks />
    </Footer>
  </Layout>
)
