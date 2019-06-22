# Random Quote Machine

![A screenshot of the Random Quote Machine](/random-quote-machine.png)

This Elm app is based on [freeCodeCamp](https://www.freecodecamp.com/)'s
[Build a Random Quote Machine](https://learn.freecodecamp.org/front-end-libraries/front-end-libraries-projects/build-a-random-quote-machine/)
front-end project. Its look and feel is "borrowed" from
[this example](https://codepen.io/freeCodeCamp/full/qRZeGZ) CodePen app.

## Takeaways

I learned a few new things by taking the time to build it.

1. I discovered Michael Bylstra's [HTML to Elm](http://mbylstra.github.io/html-to-elm/)
app. It got me quickly from a
[static version](https://github.com/elm-school/random-quote-machine/commit/cee9a531432dd119d6679376ee65376c5a68216e)
to the bare bones Elm version in no time at all.

2. I got more experience dealing with
[random](https://github.com/elm-school/random-quote-machine/commit/21810eb133ab6d28962c3b92f33ebedbb2174a86)
behaviour. When the "New quote" button is clicked a random quote is selected and
displayed.

3. I figured out how to build URLs. For e.g. I had to use
[Url.Builder](https://package.elm-lang.org/packages/elm/url/latest/Url-Builder)
to build
[the tweet web intent URL](https://github.com/elm-school/random-quote-machine/commit/5437a5396c425de31ba30133b8086d041c2a5446#diff-de84bd170bc37fbce0a7076c0125dd29R80).

4. And last but not least, I learned how to
[handle simple transitions](https://github.com/elm-school/random-quote-machine/commit/d88518b2e9d9a7efb5e2a732456d88486efb7625)
that are based in CSS.

## That's all folks!

Check out the [app](https://elm-school.github.io/random-quote-machine/) and enjoy the quotes.

Let me end with one of my favourite quotes that I think embodies the spirit of
Elm.

> Less mental clutter means more mental resources available for deep thinking. ~ Cal Newport, [Deep Work: Rules for Focused Success in a Distracted World](http://www.calnewport.com/books/deep-work/)
