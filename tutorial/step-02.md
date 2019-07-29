# Step 2

In this step our goal is to style the app using CSS. When we complete this step
our app will look like the following:

![A screenshot of the app after step 2 is completed.](assets/step-02-final.png)

## Plan

1. [Set up for CSS](#set-up-for-css).
2. [Style the body](#style-the-body).
3. [Style the background](#style-the-background).
4. [Style the quotation box](#style-the-quotation-box).
5. [Style the attribution](#style-the-attribution).

## Set up for CSS

In your project's root directory, create a new directory named `assets` and in
it create a `styles.css` file.

```sh
$ mkdir assets
$ touch assets/styles.css
```

Open the `index.html` file and add a link to the stylesheet just after the
Font Awesome link.

```html
<link rel="stylesheet" href="assets/styles.css">
```

**N.B.** *In the steps below, any CSS you have to add goes into
`assets/styles.css` and any HTML edits to add classes to the elements goes into
`index.html`.*

## Style the body

```css
@import url("https://fonts.googleapis.com/css?family=Raleway:400,500");

/* General */

body {
  margin: 0;
  height: 100vh;

  font-family: Raleway, sans-serif;
  font-weight: 400;
}
```

The [Raleway](https://fonts.google.com/specimen/Raleway) font is imported from
[Google Fonts](https://fonts.google.com/) and only the 400 and 500
weights are requested since that's all we'll need for this project.

The `body`'s default margin is removed and its height is set to be 100% of the
viewport's height. This sets the stage for when we need to place everything
in the middle of the viewport&mdash;which we do next.

## Style the background

```html
<!-- Background -->
<div class="background">
  <!-- Wraps the quotation box and attribution -->
  <div>
    <!-- ... -->
  </div>
</div>
```

```css
/* Background */

.background {
  height: 100vh;

  display: flex;
  align-items: center;
  justify-content: center;

  background-color: #333;
}
```

By default, the `.background`'s height is the height of its content. However,
we need it to extend to the height of the viewport.

The `.background` uses
[flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)
to layout its elements. The `div` that wraps the quotation box and attribution
is the sole child element of the `.background` and so it will be placed in the
middle of the viewport.

**Question:** Is the `.background` really necessary? Couldn't we just put all
the styles on the `body`? What do you think?

## Style the quotation box

```html
<!-- Quotation box -->
<div class="quote-box">
  <!-- Quote and author -->
  <blockquote class="quote-box__blockquote">
    <!-- Quote -->
    <p class="quote-box__quote-wrapper">
      <span class="quote-left"><i class="fa fa-quote-left"></i></span>...
    </p>
    <!-- Author -->
    <footer class="quote-box__author-wrapper">
      &#8212; <cite class="author">...</cite>
    </footer>
  </blockquote>

  <!-- Actions -->
  <div class="quote-box__actions">
    <!-- Tweet it -->
    <div>
      <a href="..." target="_blank" class="icon-button"><i class="fa fa-twitter"></i></a>
    </div>
    <!-- Post to Tumblr -->
    <div>
      <a href="..." target="_blank" class="icon-button"><i class="fa fa-tumblr"></i></a>
    </div>
    <!-- Get a new quote -->
    <div>
      <button type="button" autofocus class="button">New quote</button>
    </div>
  </div>
</div>
```

```css
/* Quote box */

.quote-box {
  width: 450px;
  padding: 40px 50px;

  border-radius: 3px;

  color: #333;
  background-color: #fff;
}

.quote-box__blockquote {
  margin: 0 0 30px 0;
}

.quote-box__quote-wrapper {
  margin-top: 0;

  text-align: center;
  font-size: 1.8rem;
}

.quote-box__quote-wrapper .quote-left {
  margin-right: 12px;
}

.quote-box__author-wrapper {
  text-align: right;
}

.quote-box__author-wrapper .author {
  font-style: italic;
}

.quote-box__actions {
  display: flex;
}

.quote-box__actions .button {
  height: 30px;

  padding-left: 15px;
  padding-right: 15px;

  border: 0;
  border-radius: 3px;

  cursor: pointer;

  color: #fff;
  background-color: #333;
}

.quote-box__actions .icon-button {
  display: flex;
  align-items: center;
  justify-content: center;

  width: 40px;
  height: 30px;

  border-radius: 3px;

  text-decoration: none;

  color: #fff;
  background-color: #333;
}

.quote-box__actions .button:hover,
.quote-box__actions .icon-button:hover {
  opacity: 0.9;
}

.quote-box__actions > div:first-child {
  margin-right: 10px;
}

.quote-box__actions > div:last-child {
  margin-left: auto;
}
```

## Style the attribution

```html
<!-- Attribution -->
<footer class="attribution">
  by <a href="https://github.com/dwayne/" target="_blank" class="attribution__link">dwayne</a>
</footer>
```

```css
/* Attribution */

.attribution {
  margin-top: 15px;

  text-align: center;
  font-size: 0.8rem;

  color: #fff;
}

.attribution__link {
  text-decoration: none;
  font-weight: 500;

  color: #fff;
}
```

The end. Go to [step 3](step-03.md).
