import Layout from '../layouts/main'
import Header from '../components/header'
import Lead from '../components/lead'
import Footer from '../components/footer'
import GroupedItems from '../components/grouped-items';
import Panel from '../components/panel';

import { guides } from '../data'

export default () => (
  <Layout title="Free Cooking Guides">
    <Header/>
    <Lead tagline="Free Cooking Guides" subheading="Click and enter your email to download any of these resources."/>
    <GroupedItems items={guides} groupCount={3} Component={Panel}/>
    <Lead tagline="Want more?" subheading="Have an idea of something you want to see here? Let me know!"/>
    <Footer/>
  </Layout>
)
