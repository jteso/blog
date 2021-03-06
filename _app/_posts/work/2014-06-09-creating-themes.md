---
layout: post
title: Creating Your Own Theme
category: note
tags: customization
---

## Overview

You can create your own theme in AMSF, theme files are located in the following location (I use default theme Curtana here for better understanding):

```
├── _app/
|   ├── _data/
|   |   └── curtana.yml
|   ├── _includes/
|   |   └── themes/
|   |   |   └── curtana/
|   |   |   |   └── includes/
|   |   |   |   └── layouts/
|   ├── _pages/
|   |   └── themes/
|   |   |   └── curtana/
|   |   |   |   └── example-page.md
|   |   |   |   └── ...
|   ├── assets/
|   |   └── themes/
|   |   |   └── curtana/
|   |   |   |   └── _js/
|   |   |   |   └── _less/
|   |   |   |   └── ...
```

The theme specific config `curtana.yml` should have the same filename as your theme name. It should contain theme specific variables and can also override AMSF built-in settings.

More info about theme structure you can check out my default theme [Curtana](http://github.com/amsf/amsf-curtana).

You can also have multiple themes in your project, as many as you like. For example if you also have themes Bootstrap and Ghost installed, the file structure should be:

```
├── _app/
|   ├── _data/
|   |   └── bootstrap.yml
|   |   └── curtana.yml
|   |   └── ghost.yml
|   ├── _includes/
|   |   └── themes/
|   |   |   └── bootstrap/
|   |   |   |   └── includes/
|   |   |   |   └── layouts/
|   |   |   └── curtana/
|   |   |   |   └── includes/
|   |   |   |   └── layouts/
|   |   |   └── ghost/
|   |   |   |   └── includes/
|   |   |   |   └── layouts/
|   ├── _pages/
|   |   └── themes/
|   |   |   └── bootstrap/
|   |   |   |   └── example-about.md
|   |   |   |   └── example-blog.md
|   |   |   |   └── example-fluid-container.md
|   |   |   |   └── ...
|   |   |   └── curtana/
|   |   |   |   └── example-about.md
|   |   |   |   └── example-news.md
|   |   |   |   └── ...
|   |   |   └── ghost/
|   |   |   |   └── example-archive.md
|   |   |   |   └── example-page.md
|   |   |   |   └── example-tagcloud.md
|   |   |   |   └── ...
|   ├── assets/
|   |   └── themes/
|   |   |   └── bootstrap/
|   |   |   |   └── _coffee/
|   |   |   |   └── _less/
|   |   |   |   └── images/
|   |   |   └── curtana/
|   |   |   |   └── _js/
|   |   |   |   └── _less/
|   |   |   |   └── svg/
|   |   |   └── ghost/
|   |   |   |   └── _js/
|   |   |   |   └── _scss/
|   |   |   |   └── fonts/
...
```

## AMSF Options

There're several built-in options you can use in your theme. These options can also be overridden in theme specific config.

### `site.name`

Template:

```html
<footer class="footer">
  <ul>
    <li><a href="/">{{ "{{ site.name " }}}}</a></li>
    <li><a href="/atom.xml">Atom</a></li>
  </ul>
</footer>
```

Output:

```html
<footer class="footer">
  <ul>
    <li><a href="/">Almace Scaffolding</a></li>
    <li><a href="/atom.xml">Atom</a></li>
  </ul>
</footer>
```

### `site.description`

Site description, will appear in the document meta and Atom feed subtitle.

Template:

```html
<meta property="og:description" content="{{ '{{ site.description ' }}}}">
```

Output:

```html
<meta property="og:description" content="Super-fast Jekyll framework">
```

### `site.base`

Base URL, this is useful when you need to build site in a subdirectory (like GitHub Pages for Projects), it provides a specific URL prefix, for example, if the production site URL is http://sparanoid.com/lab/amsf/, set `base` to `/lab/amsf`, without trailing slash. This make sure all the links are relative to current site root (in a subdirectory in this case), you should use this variable for **every** link appeared in your theme.

Config:

```yaml
base: /lab/amsf
```

Template:

```html
<a href="{{ '{{ site.base ' }}}}/atom.xml">Atom</a>
```

Output:

```html
<a href="/lab/amsf/atom.xml">Atom</a>
```

### `site.file`

Media assets URL used in posts, without trailing slash. In the most cases this URL should be powered by a CDN provider.

Config:

```yaml
file: //d349cztnlupsuf.cloudfront.net
```

Template:

```html
<img src="{{ '{{ site.file ' }}}}/post-thumbnail.jpg">
```

Output:

```html
<img src="//d349cztnlupsuf.cloudfront.net/post-thumbnail.jpg">
```

### `site.twitter`

Site Twitter account handle.

Template:

```html
<a href="http://twitter.com/{{ '{{ site.twitter ' }}}}">Follow @{{ '{{ site.twitter ' }}}} on Twitter</a>
```

Output:

```html
<a href="http://twitter.com/sparanoid">Follow @sparanoid on Twitter</a>
```

### `site.force_utf_8`

Force UTF-8 encoding, enable this will simply add `<meta charset="utf-8">` to the head of your pages.

Template:

```html
{{ '{% if site.force_utf_8 ' }}%}
  <meta charset="utf-8">
{{ '{% endif ' }}%}
```

## Theme Features

There're some features can be integrated into your theme.

### (Basic) Multi-Language Support

You can define post / page language in your front-matter field:

```yaml
languages:
  - zh-tw
```

An additional `lang` HTML attribute will be added to your final rendering:

```html
<article lang="zh-tw">
  ...
</article>
```

If your post / page content is multilingual, you can also define multiple languages in array:

```yaml
languages:
  - zh-tw
  - en-us
```

Please note that only the first item defined in `languages` array will be used in final `lang` ouput, the additional languages will be available in JSON feed output:

```json
{
  "languages": ["zh-tw", "en-us"],
  "categories": ["note"],
  "tags": ["miscellaneous"]
}
```

### Smooshing Assets

For better performance, Almace Scaffolding will find all the CSS, script links and images in compiled HTML, and outputs a version with all the CSS, scripts and images (Base64) written inline. Sounds cool? but it needs theme support. Here's how:

You can simply add the query string `?assets-inline` at the end of the file you'd like to be smooshed in production site:

```html
<!-- This CSS will be smooshed into HTML -->
<link rel="stylesheet" href="{% raw %}{{ '/css/app.css?assets-inline' | prepend: amsf_theme_assets }}{% endraw %}">

<!-- This script will be smooshed into HTML -->
<script src="{% raw %}{{ '/js/app.js?assets-inline' | prepend: amsf_theme_assets }}{% endraw %}"></script>
```

### User Custom Styles Support

Define the following code snippet into your theme styles (Less) will allow users to custom your theme without touching the theme files:

```css
// Import user custom styles
@import "../../../_less/custom";
```

### User Custom Scripts Support

Define the following code snippet into your theme template (it's recommended to put it in footer) will allow users to add custom scripts without touching the theme files:

```html
<!-- User custom scripts -->
<script src="{% raw %}{{ '/js/custom.js?assets-inline' | prepend: amsf_user_assets }}{% endraw %}"></script>
```

### Page / Post Specific CSS Block Support

This allow your user to define page / post specific CSS blocks in front-matter data:

```html
<!-- Page-wide custom CSS -->
{% raw %}{{ amsf_page_css }}{% endraw %}
```

### Google Analytics Support

This allow your user to be able to use Google Analytics for their site, tracking ID can be changed in config file:

```html
<!-- Google Analytics tracking code -->
{% raw %}{{ amsf_google_analytics }}{% endraw %}
```

## Publishing Themes

You really like your custom design and wanna show it off to the world? Cool, you can create (pack) you own theme by the following command:

```sh
$ grunt theme-save
```

The activated theme will be saved to AMSF cache (`_amsf/`) with correct file and directory structure, then you can upload your theme to GitHub.

Still confusing? see my default theme [Curtana](http://github.com/amsf/amsf-curtana) for reference.
