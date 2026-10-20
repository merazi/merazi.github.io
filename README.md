# Merazi's Blog

Source code for [merazi.github.io](https://merazi.github.io), a personal blog focused on Linux, digital minimalism, older hardware, and productivity.

Powered by [Hugo](https://gohugo.io/) and the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

---

## 🛠 Local Development

To run the blog locally with live-reload:

```bash
hugo server -D
```

Then open `http://localhost:1313/` in your browser.

## ✍️ Creating a New Post

To create a new draft post using the default archetype:

```bash
hugo new posts/my-post-title.md
```

This creates a new markdown file in `content/posts/` with pre-filled frontmatter:

```markdown
---
title: "My Post Title"
date: 2026-10-19T22:00:00-06:00
draft: false
tags: ["linux", "productivity"]
description: "Brief summary of the post"
showToc: true
mastodon_url: "https://mastodon.social/@ttydweller/..."
---
```

Set `draft: false` when you are ready to publish.

## 🚀 Deployment

The site is automatically built and deployed to GitHub Pages via GitHub Actions (`.github/workflows/hugo.yml`) whenever changes are pushed to the `main` branch.

## 📁 Project Structure

```
├── archetypes/         # Template for new posts
├── content/
│   ├── posts/          # Blog posts in Markdown
│   ├── archives.md     # Post archive index
│   └── search.md       # Client-side instant search
├── layouts/
│   └── partials/       # Custom extensions (footer badges, Mastodon CTA)
├── static/
│   ├── buttons/        # Web badges (Microhate, Linux Powered, etc.)
│   ├── logo.png        # Profile and site icon
│   └── music-logo.png  # Music icon
├── themes/PaperMod/    # PaperMod submodule
└── hugo.toml           # Site configuration
```
