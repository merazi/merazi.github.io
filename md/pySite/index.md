---
title: PySite static website generator
date: 2025-12-20
---

# I Built My Own Site Generator with Python

So, I did it again... I rebuilt my entire website.

But this time feels different. Why? Because I built the static site generator myself, completely from scratch, using Python.

Say hello to **Pysite**.

I made it to be super simple and straightforward. No crazy dependencies, no complicated setup. Just the basics to get a blog or a simple site up and running fast.

If you wanna check it out, you can grab it from my GitHub:
[https://github.com/merazi/blogcraft](https://github.com/merazi/blogcraft)

Getting your own site running is a piece of cake. Seriously, it's pretty much this:

1.  Create your `config.json` file to set things up.
2.  Pop open your terminal and create a new post:
    ```bash
    pysite new new-post
    ```
3.  Build the site:
    ```bash
    pysite build
    ```
4.  Profit. 😎

**Pro-tip for hosting:** If you're using something like GitHub Pages, just point it to the output directory. You can set this in your `config.json` with the `public_dir` option.

That's it! Go have some fun with it. 🍎