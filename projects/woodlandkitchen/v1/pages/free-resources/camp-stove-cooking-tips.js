import Layout from '../../layouts/with-nav'
import Img from '../../components/img'
import Container from '../../components/container'

import { guides } from '../../data'

export default () => (
  <Layout title={guides[1].title}>
    <Container
      title={guides[1].title}
      img={<Img id={guides[1].imgId}/>}
    />
  </Layout>
)
