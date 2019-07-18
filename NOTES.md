# Notes

Miscellaneous notes and ideas.

## Use `<main>` for the wrapper

> The HTML `<main>` element represents the dominant content of the `<body>` of
a document. ~ [&lt;main&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/main)

This is why I think the quotation box and attribution should be wrapped in
`<main>` rather than a `<div>` which has no semantic meaning.

```html
<!-- Background -->
<div class="background">
  <!-- Wraps the quotation box and attribution -->
  <main>
    <!-- ... -->
  </main>
</div>
```

## mbylstra's [HTML to Elm](http://mbylstra.github.io/html-to-elm/) app crashes

When I put the following HTML:

```html
<!-- Background -->
<div class="background">
  <!-- Wraps the quotation box and attribution -->
  <div>
    <!-- Quotation box -->
    <div class="quote-box">
      <!-- Quote and author -->
      <blockquote class="quote-box__blockquote">
        <!-- Quote -->
        <p class="quote-box__quote-wrapper">
          <span class="quote-left"><i class="fa fa-quote-left"></i></span>I am not a product of my circumstances. I am a product of my decisions.
        </p>
        <!-- Author -->
        <footer class="quote-box__author-wrapper">
          &#8212; <cite class="author">Stephen Covey</cite>
        </footer>
      </blockquote>

      <!-- Actions -->
      <div class="quote-box__actions">
        <!-- Tweet it -->
        <div>
          <a href="https://twitter.com/intent/tweet?hashtags=quotes&text=%22I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.%22%20~%20Stephen%20Covey" target="_blank" class="icon-button"><i class="fa fa-twitter"></i></a>
        </div>
        <!-- Post to Tumblr -->
        <div>
          <a href="https://www.tumblr.com/widgets/share/tool?posttype=quote&tags=quotes&content=I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.&caption=Stephen%20Covey&canonicalUrl=https%3A%2F%2Fwww.tumblr.com%2Fdocs%2Fen%2Fshare_button" target="_blank" class="icon-button"><i class="fa fa-tumblr"></i></a>
        </div>
        <!-- Get a new quote -->
        <div>
          <button type="button" autofocus class="button">New quote</button>
        </div>
      </div>
    </div>

    <!-- Attribution -->
    <footer class="attribution">
      by <a href="https://github.com/dwayne/" target="_blank" class="attribution__link">dwayne</a>
    </footer>
  </div>
</div>
```

It crashes the HTML to Elm app.

```
Error: Ran into a `Debug.crash` in module `Parser.Parser`

This was caused by the `case` expression between lines 276 and 280.
One of the branches ended with a crash and the following value got through:

    [UnlabelledAstNode (AstChildren ([LabelledAstNode { label = "OPENING_TAG", value = AstChildren ([UnlabelledAstNode (AstLeaf "div"),UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstLeaf "class")])),UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstLeaf "background")]))]))]))]) },LabelledAstNode { label = "OPENING_TAG", value = AstChildren ([UnlabelledAstNode (AstLeaf "div"),UnlabelledAstNode (AstChildren [])]) },LabelledAstNode { label = "OPENING_TAG", value = AstChildren ([UnlabelledAstNode (AstLeaf "div"),UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstLeaf "class")])),UnlabelledAstNode (AstChildren ([UnlabelledAstNode (AstLeaf "quot…
```

And it doesn't recover unless you refresh the page.

## Can an em dash be used for quote attribution?

- https://english.stackexchange.com/q/28601
- https://www.thepunctuationguide.com/em-dash.html
