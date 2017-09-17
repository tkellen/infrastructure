import Layout from '../../layouts/with-nav'
import Img from '../../components/img'
import Container from '../../components/container'

import { guides } from '../../data'

export default () => (
  <Layout title={guides[0].title}>
    <Container
      title={guides[0].title}
      img={<Img id={guides[0].imgId}/>}
    />
  </Layout>
)
