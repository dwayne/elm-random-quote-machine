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
