# Step 1

## Goal

To structure the app using HTML.

This is what you will be trying to reproduce:

![Screenshot of the app after step 1 is completed](assets/step-01-final.png)

## Plan

1. Create a project directory.
2. Write an `index.html`.
3. View the `index.html` in a browser.

## Create a project directory

Create a directory named `random-quote-machine`, change into it and create a
file called `index.html`.

```sh
$ mkdir random-quote-machine
$ cd random-quote-machine
$ touch index.html
```

## Write an `index.html`

Start with the following:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Random Quote Machine</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
  </head>
  <body>
    <!-- ... -->
  </body>
</html>
```

In the body add a `div` for the background and within that add a `div` that
wraps the quotation box and attribution.

```html
<!-- Background -->
<div>
  <!-- Wraps the quotation box and attribution -->
  <div>
    <!-- Quotation box -->

    <!-- Attribution -->
  </div>
</div>
```

The quotation box contains a quote and its author along with actions to either
tweet the quote, post the quote to Tumblr or to get a new quote. Replace the
quotation box comment with the following HTML:

```html
<div>
  <!-- Quote and author -->
  <blockquote>
    <!-- Quote -->
    <p>
      <span><i class="fa fa-quote-left"></i></span>I am not a product of my circumstances. I am a product of my decisions.
    </p>
    <!-- Author -->
    <footer>
      &#8212; <cite>Stephen Covey</cite>
    </footer>
  </blockquote>

  <!-- Actions -->
  <div>
    <!-- Tweet it -->
    <div>
      <a href="https://twitter.com/intent/tweet?hashtags=quotes&text=%22I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.%22%20~%20Stephen%20Covey" target="_blank"><i class="fa fa-twitter"></i></a>
    </div>
    <!-- Post to Tumblr -->
    <div>
      <a href="https://www.tumblr.com/widgets/share/tool?posttype=quote&tags=quotes&content=I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.&caption=Stephen%20Covey&canonicalUrl=https%3A%2F%2Fwww.tumblr.com%2Fdocs%2Fen%2Fshare_button" target="_blank"><i class="fa fa-tumblr"></i></a>
    </div>
    <!-- Get a new quote -->
    <div>
      <button type="button" autofocus>New quote</button>
    </div>
  </div>
</div>
```

**Notes:**

- Read the Tweet
[Web Intent](https://developer.twitter.com/en/docs/twitter-for-websites/tweet-button/guides/web-intent.html)
guide to learn how the Twitter web intent URL was generated.
- Read the
[Share Button Documentation](https://www.tumblr.com/docs/en/share_button) to
learn how the Tumblr share URL was generated.

The "New quote" button is the primary call to action on the page so it is given
focus (via the `autofocus` attribute) when the page loads.

Finally, replace the attribution comment with the following HTML:

```html
<footer>
  by <a href="https://github.com/dwayne/" target="_blank">dwayne</a>
</footer>
```

Feel free to change the URL and the name to whatever you prefer.

## View the `index.html` in a browser

I usually just open another terminal window and start a
[SimpleHTTPServer](https://docs.python.org/2/library/simplehttpserver.html)
with [python](https://docs.python.org/2/using/cmdline.html).

```sh
$ python -m SimpleHTTPServer
```

But I recommend that you use any other option that is convenient to you.

In my case an HTTP server is started that serves the contents of the current
directory, `path/to/random-quote-machine`, at http://localhost:8000/.
