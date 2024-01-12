# Plan

The general plan is to build an Elm web application from scratch that is functionally similar to this: [https://random-quote-machine.freecodecamp.rocks/](https://random-quote-machine.freecodecamp.rocks/).

Since, I don't want to focus on designing anything I will also "borrow" its look and feel.

## Process

I will take a bottom-up approach and build the app incrementally from start to finish. It's a simple three part process:

1. [HTML & CSS](#html--css)
2. [Elm](#elm)
3. [Deploy](#deploy)

### HTML & CSS

I will deconstruct the existing app and rebuild a static version of it in HTML and CSS. This will be done for several reasons:

1. I want to figure out my own structure for the HTML.
2. I want to write my own CSS (via Sass).
3. I want to show the entire process from when you're only given a design to a finished Elm web application.
4. I want to solve any structural and styling issues before writing any Elm. I have found that when I do this correctly I only ever have to focus on adding interactivity and business logic when writing the Elm code.

**N.B.** *I refer to the output of this step in the process as the prototype.*

### Elm

In this part I will translate all the HTML to Elm view functions. Then, I'd start bringing the app to life by adding the interactivity and business logic.

It may seem surprising to you that I didn't jump right in and start coding Elm. After all, Elm is such a great language and we'd want to do everything in Elm. Right?

It certainly is emotionally satisfying to do that. However, I have found that when I follow this process I have an easier time building the app, I have a clearer understanding of the app, and I end up producing better Elm code.

Those are all subjective claims that I can't justify to you right at this moment. But, if you decide to join me on this journey through this guide and you make it to the end then maybe you might experience some of what I'm saying.

**N.B.** *I refer to the output of this step in the process as the application.*

### Deploy

Finally, I will write a bash script to deploy an optimized version of the Elm web application using [GitHub Pages](https://pages.github.com/).
