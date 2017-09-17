import Layout from '../../layouts/without-nav'
import Lead from '../../components/lead'
import EmailSignup from '../../components/email-signup'
import Router from 'next/router'

export default () => (
  <Layout title='Join The Revolution'>
    <Lead
      type="signup"
      tagline="Where am I? Why Am I here?"
      subheading="What will happen if I do what this thing is asking?"
    >
      <EmailSignup
        listId="ba733fba79"
        groupId="2bd0ac42d9"
        endpoint="/email-register"
        baseUrl="/join"
        errorUrl="/error"
        router={Router}
      />
    </Lead>
  </Layout>
)
