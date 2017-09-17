import pluralize from '../utils/pluralize'
import theme from '../theme'

import { recipe, ingredients } from '../data'

const DECIMAL_TO_DISPLAY = {
  '0.25': '¼',
  '0.33': '⅓',
  '0.5': '½',
  '0.75': '¾',
  '0.66': '⅔'
}

function displayAmount (input) {
  const wholeQty = Math.floor(input)
  const fractionalQty = input - wholeQty
  const output = []
  if (wholeQty > 0) {
    output.push(wholeQty)
  }
  if (fractionalQty > 0) {
    output.push(DECIMAL_TO_DISPLAY[fractionalQty])
  }
  return output.join(' ')
}

function prepIngredients (input) {
  return input.reduce((carry, currentIngredient, idx) => {
    const nextIngredient = input[idx + 1]
    const lastIngredient = input[idx - 1]
    if (lastIngredient && nextIngredient && currentIngredient.name === lastIngredient.name) {
      return carry
    }
    if (nextIngredient && currentIngredient.name === nextIngredient.name) {
      currentIngredient.amount += nextIngredient.amount
    }
    if (currentIngredient.amount >= 1) {
      currentIngredient.volume_display = pluralize(currentIngredient.volume_display)
    }
    carry.push(currentIngredient)
    return carry
  }, [])
}

export default (props) => (
  <div>
    <style jsx>{`
      * + * {
        margin-top: 8vw;
      }
      p:first-of-type:first-line {
        /* first line of content post + first line after any hr should
         * be made a bit more visible */
        font-weight: 600;
        font-size: 1.1em;
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
      ul {
        padding: 0;
        list-style: none;
      }
      ul > li {
        margin: 0 !important;
        padding: 0;
      }
      @media(${theme.mediumScreen}) {
        * + * {
          margin-top: 4vw;
        }
        h1 {
          position: absolute;
          font-size: 3em;
        }
      }
      @media(${theme.largeScreen}) {
        * + * {
          margin-top: 2vw;
        }
      }
    `}</style>
    <p>{recipe.description}</p>
    <h2>Ingredients</h2>
    <ul>{prepIngredients(ingredients).map(i => (
      <li><span className='qty'>{displayAmount(i.amount)}</span> {i.volume_display} {i.name} {i.note} {i.options}</li>
    ))}</ul>
    <h2>Intructions</h2>
    <p>Measure the currants into a small bowl and drizzle the brandy over them. While they soak for a bit, begin preparing the rest of your ingredients: in a large bowl, whisk together the flour, cocoa powder, baking powder, baking soda, spices, salt, and dark chocolate. (Pro tip: do not slice your finger open grating chocolate by hand.)</p>
    <p>In a separate bowl, cream the butter, sugar, vanilla, and lemon and orange zest until it's smooth and creamy. Add the half an egg (you can crack it in a bowl, use a fork to mix the white and yolk as you would for scrambled eggs, and pour in half), and mix thoroughly. Add the dry ingredients, and then dump in the currants and brandy. Stir until everything comes together.</p>
    <p>Knead the dough gently with your hands until it becomes a uniform blob. </p>
    <p>Using a kitchen scale, weigh the dough into 50 gram chunks, and roll each one into ball in your palms until it's perfectly round and shiny. Place the balls on a baking sheet (lined with parchment, if yours is prone to sticking), leaving just shy of an inch between them. Pop the dough balls in the fridge to rest. Once they'd chilled, I transferred mine to a ziploc bag and left them in the fridge for three days before baking, but you can bake yours after as little as an hour.</p>
    <p>Preheat the oven to 375°F, and bake the cookies for 12-15 minutes, until they firm up, and some of the balls have cracked open. Take the pan out of the oven. Let the cookies cool for a few minutes on the pan, then transfer them to a wire rack.</p>
    <p>When the cookies are just barely still warm, mix the icing ingredients together until the glaze is smooth. Set the cooling rack over a cookie sheet to catch icing drips. When your tray is ready, pour a little of the glaze over each cookie. I ended up double-coating my cookies to leave a more substantial coating. While the icing is still wet, decorate the top of each cookie with two or three pieces of minced crystallized ginger and candied orange peel.</p>
  </div>
)
