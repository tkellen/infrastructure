import Layout from '../../layouts/with-nav'
import Lead from '../../components/lead'
import GroupedItems from '../../components/grouped-items'
import Panel from '../../components/panel'

import { guides } from '../../data'

export default () => (
  <Layout title="Free Resources">
    <Lead tagline="Free Resources" subheading="Click and enter your email to download any of these resources." />
    <GroupedItems items={guides} groupCount={3} Component={Panel} />
    <Lead tagline="Want more?" subheading="Have an idea of something you want to see here? Let me know!" />
  </Layout>
)
