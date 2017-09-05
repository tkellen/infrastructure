import Lead from './lead'

//todo, make this actually work!
export default () => (
  <Lead type="signup" tagline="Get signed up." subheading="Don't miss a thing!">
    <form action="//goingslowly.us6.list-manage.com/subscribe/post?u=97094f70bf583862c9bd412fa&amp;id=ba733fba79" method="post" target="_blank" noValidate>
      <input type="email" value="" name="EMAIL" placeholder="Email" required/><br/>
      <div className="hidden" aria-hidden="true"><input type="text" name="b_97094f70bf583862c9bd412fa_ba733fba79" tabIndex="-1" value=""/></div>
      <input type="submit" className="action-button" value="Take me to the woods!" name="subscribe"/>
    </form>
  </Lead>
)
