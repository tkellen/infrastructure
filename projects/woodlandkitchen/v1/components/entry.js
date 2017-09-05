import Container from './container'
import Img from '../components/img'

import theme from '../theme'

export default (props) => (
  <div className="entry">
    <style jsx>{`
      p:first-of-type:first-line, hr + p:first-line {
        /* first line of content post + first line after any hr should
         * be made a bit more visible */
        font-weight: 600;
        font-size: 1.1em;
      }
      hr {
        background: transparent;
        outline: none;
        height: 0;
        border: none;
        border-top: 2px solid ${theme.colors.gray};
      }
      a {
        color: ${theme.colors.bodyLink};
        text-decoration: none;
        font-weight: 200;
      }
      a:hover {
        text-decoration: underline;
        color: ${theme.colors.bodyLinkHighlight};
      }
      a:visited {
        color: ${theme.colors.bodyLinkVisited};
      }
      p {
        margin: 0;
      }
      strong {
        font-weight: 600;
      }
      em {
        font-style: italic;
      }
      h3 {
        font-size: 1.5em;
        line-height: 1.25em;
        font-weight: 400;
      }
      aside {
        box-sizing: border-box;
        position: relative;
        padding: 6vw;
        font-size: 1.1em;
        line-height: 1.35em;
        font-weight: 400;
        background-color: #222;
        margin: 0;
      }
      cite {
        font-style: normal;
        display: block;
        line-height: 1.2em;
        margin-top: 5vw;
        text-align: right;
        font-family: "${theme.fonts.sansSerif}";
        font-weight: 200;
        margin: 0;
      }
      ol {
        list-style-type: none;
        list-style-type: decimal !ie; /*IE 7- hack*/
        margin: 0 8vw 0 8vw;
        padding: 0;
        counter-reset: li-counter;
      }
      ol > li {
        position: relative;
        margin-bottom: 1em;
        padding-left: 0.5em;
        min-height: 3em;
        border-left: 2px solid ${theme.colors.gray};
      }
      ol > li:before {
        position: absolute;
        top: 0;
        left: -1em;
        width: 0.8em;
        font-size: 2em;
        line-height: 1;
        font-weight: bold;
        text-align: right;
        color: ${theme.colors.gray};
        content: counter(li-counter);
        counter-increment: li-counter;
      }
      ul {
        padding: 0;
        margin: 0 8vw 0 8vw;
        list-style: none;
      }
      ul > li {
        padding-left: 0.5em;
      }
      ul > li:before {
        margin: -0.5vw 0 0 -3.5vw;
        float: left;
        font-size: 7vw;
        content: "•";
        color: ${theme.colors.gray};
      }

      /* the global for img has to be there because the images are
       * another component which will not receive the styling
       * otherwise */
      :global(.entry img) {
        margin: 8vw 0 8vw -7vw;
        width: 107vw !important;
      }
      @media(${theme.mediumScreen}) {
        * + * {
          margin-top: 4vw;
        }
        hr {
          /* bump up margin size at large screens to make hr
           * differentiate page sections more prominently. the
           * important is here to override the owl operator
           * above */
          margin: 7vw 0 !important;
        }
        aside {
          border-left: .7vw solid ${theme.colors.gray};
          margin: auto -7vw;
          padding: 6vw 4vw 4vw 4vw;
        }
        /* we only add the quote on larger screens
         * where there is room to show it! */
        aside:after {
          position: absolute;
          top: 5vw;
          left: -2vw;
          content: '“';
          font-size: 8em;
          font-family: Georgia;
          color: ${theme.colors.gray};
          opacity: 1;
        }
        /* the global for img has to be there because the images are
         * another component which will not receive the styling
         * otherwise */
        :global(.entry img) {
          margin: 4vw 0vw 4vw -7vw;
          width: 93.75vw !important;
        }
      }
      @media(${theme.largeScreen}) {
        * + * {
          margin-top: 2vw;
        }
        aside {
          /* this overrides the owl operator below */
          margin: 4vw -10vw !important;
        }
        aside:after {
          top: 6vw;
          left: -2vw;
          font-size: 12em;
        }
        cite {
          margin-top: 2vw;
        }
        /* the global for img has to be there because the images are
         * another component which will not receive the styling
         * otherwise */
        :global(.entry img) {
          margin-top: 4vw;
          margin-bottom: 4vw;
          margin-left: -10vw;
          width: 90vw !important;
        }
      }
    `}</style>
    <p>As you've probably gathered by now, I have a thing about the past. And by 'thing,' I mean that I, on occasion, become awash in a bone-deep ache for an earlier time. I yearn to experience life in a Tudor village, or travel Canterbury Tales-style from tavern to tavern. Even though I'm fortunate enough to live on ten acres of woodland, I would give a lot to be able to experience its wildness without the drone of planes flying overhead or the buzz of vehicles from two local highways.</p>
    <aside>
      <p>Einstein said that time is like a river, it flows in bends. If we could only step back around the turns, we could travel in either direction. I'm sure it's possible. When I die, I'm going right back to the 1830s.</p>
      <cite>Tasha Tudor</cite>
    </aside>
    <p>(Granted, I am not so naive as to think it would be idyllic. The all-consuming grind of cooking, laundry, and cleaning would probably drive me insane within the space of day, and I'd surely be burned as a witch within the space of a month. But still. Just as Tyler longs to explore space, I long to explore time.)</p>
    <Img id="30762565764"/>
    <p>And yet, despite my nostalgia, I also have the opposite thought on a regular basis: <em>I am so thankful I live in this time.</em> My gratitude is for many things (a modicum&mdash;but not much more&mdash;of social equality, washing machines, jeans, etc.) but the one I keep coming back to is this: <strong>I have access to a dazzling array of affordable foods and spices from around the globe</strong>. I can easily buy vanilla beans from Madagascar, whole nutmegs from Indonesia, an  hundreds of cardamom pods from India. Even if I can't find kaffir lime leaves at my local general store, I can order them online and they'll arrive at my door within a couple of days. Crazy!</p>
    <Img id="30794129423"/>
    <p>Crazier still is how recent this proliferation of global food availability has occurred. I mean, my <em>mom</em> can remember when she was a little girl and <em>zucchini</em> first appeared her small-town supermarket! Even more mind-boggling is the realization that surely this global spice trade cannot last forever. I have a hunch that sooner or later, we'll recognize that it isn't sustainable to use fossil fuels to ship food across the globe. Eventually, spices will once again becom  highly sought-after luxury items like they were for centuries.</p>
    <Img id="30762553254"/>
    <p>Spices were synonymous with wealth in many cultures and many eras, from Pharoah Hatshepsut to Emperor Chen-Nong to King Henry the Eighth. They were so coveted that they were the cause of shady deals and bloodshed and centuries of oppressive colonial rule. They were so prized, historically, that folks would embark on dangerous, years'-long sea voyages and desert treks and spend fortunes just to acquire them!</p>
    <aside>
      <p>Garlic and onions were the only flavourings the common [ancient Egyptian] people had in their diet.</p>
      <cite>Maguelonne Toussaint-Samat, <u>History of Food</u></cite>
    </aside>
    <p>Spices were synonymous with wealth in many cultures and many eras, from Pharoah Hatshepsut to Emperor Chen-Nong to King Henry the Eighth. They were so coveted that they were the cause of shady deals and bloodshed and centuries of oppressive colonial rule. They were so prized, historically, that folks would embark on dangerous, years'-long sea voyages and desert treks and spend fortunes just to acquire them!</p>
    <ul>
      <li>Spices were synonymous with wealth in many cultures and many eras, from Pharoah Hatshepsut to Emperor Chen-Nong to King Henry the Eighth. They were so coveted that they were the cause of shady deals and bloodshed and centuries of oppressive colonial rule. They were so prized, historically, that folks would embark on dangerous, years'-long sea voyages and desert treks and spend fortunes just to acquire them!</li>
      <li>bullet two</li>
      <li>bullet three</li>
    </ul>
    <p>Spices were synonymous with wealth in many cultures and many eras, from Pharoah Hatshepsut to Emperor Chen-Nong to King Henry the Eighth. They were so coveted that they were the cause of shady deals and bloodshed and centuries of oppressive colonial rule. They were so prized, historically, that folks would embark on dangerous, years'-long sea voyages and desert treks and spend fortunes just to acquire them!</p>
    <hr/>

    <p>Spices were synonymous with wealth in many cultures and many eras, from Pharoah Hatshepsut to Emperor Chen-Nong to King Henry the Eighth. They were so coveted that they were the cause of shady deals and bloodshed and centuries of oppressive colonial rule. They were so prized, historically, that folks would embark on dangerous, years'-long sea voyages and desert treks and spend fortunes just to acquire them!</p>
    <ol>
      <li>item 1</li>
      <li>Spices were synonymous with wealth in many cultures and many eras, from Pharoah Hatshepsut to Emperor Chen-Nong to King Henry the Eighth. They were so coveted that they were the cause of shady deals and bloodshed and centuries of oppressive colonial rule. They were so prized, historically, that folks would embark on dangerous, years'-long sea voyages and desert treks and spend fortunes just to acquire them!</li>
      <li>item 3</li>
    </ol>
    <Img id="30794115363"/>
    <p>Yes, I thank my lucky stars that I live in <em>this</em> time. Without an abundance of inexpensive spices, apple pie and pumpkin pie would be sad, homely treats. I wouldn't be able to afford to taste, much less cook, chana masala, Jamaican jerk chicken, Thai green curry, chai spice tea, or gingerbread. And what would become of Scandinavian baking, with its penchant for cardamom and caraway?</p>
    <Img id="31499170292"/>
    <h3>My new favorite Christmas treats</h3>
    <p>My new favorite Christmas treats, Yotam Ottolengi and Sami Tamimi's spice cookies from their <a href="https://www.amazon.com/Jerusalem-Cookbook-Yotam-Ottolenghi/dp/1607743949" rel="external">Jerusalem cookbook</a>, would be nigh on impossible to make in any other time by anyone except for the wealthiest royalty. The addictive little lumps are full of ingredients that were once exotic: cinnamon, ginger, nutmeg, and allspice, not to mention chocolate, orange zest, and lemon zest! An  what a shame it would be to miss out on these treats. From the first bite&mdash;cracking through an icing crust of lemon glaze, into a velvety cushion of cocoa and spice studded with little currant jewels&mdash;I was officially smitten. I have hunch you will be, too.</p>
    <Img id="31529650461"/>
    <p>And this is coming from a woman who, by all accounts, shouldn't love this recipe: I'm not usually a chocolate-with-other-flavors kind of person, and I am frequently frustrated when "spiced" baked goods fall flat from lack of taste. But <em>oh</em> these little tuffets are <em>packed</em> with a multitude of flavors, the combination of which really does work marvelously well.</p>
    <p>Like I said, these are my new favorite Christmas cookies. I do hope you'll make them. Go, revel in their delicious complexity, and appreciate the fact that you live in a time when you're able to make them at all.</p>
    <Img id="31645372455"/>
  </div>
)
