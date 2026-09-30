#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
    exit 0
fi

if (($# != 1)); then
    printf 'Usage: %s filename.html\n' "$0" >&2
    exit 2
fi

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
POSTS_DIR="$ROOT_DIR/posts"
FILENAME=$1

if [[ ! $FILENAME =~ ^[A-Za-z0-9][A-Za-z0-9_-]*\.html$ ]]; then
    printf 'Use a filename ending in .html with only letters, numbers, hyphens, and underscores.\n' >&2
    exit 2
fi

POST_FILE="$POSTS_DIR/$FILENAME"
if [[ -e $POST_FILE ]]; then
    printf 'Post already exists: %s\n' "$POST_FILE" >&2
    exit 1
fi

TITLE=${FILENAME%.html}
if [[ $TITLE =~ ^[0-9]+-(.+)$ ]]; then
    TITLE=${BASH_REMATCH[1]}
fi
TITLE=${TITLE//[-_]/ }
TITLE=${TITLE^}
POST_DATE=$(date +%F)

cat > "$POST_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">

  <head>
    <title>Merazi's webpage - $TITLE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="date" content="$POST_DATE">
    <link rel="stylesheet" href="../main.css">
    <link rel="icon" type="image/x-icon" href="../logo.png">
  </head>

  <body>
    <nav aria-label="Main navigation">
      <a href="../index.html">Go Back</a>
    </nav>

    <main>
      <article>
        <header class="post-header">
          <h1>$TITLE</h1>
        </header>

        <!-- Write the post content here. -->
      </article>
    </main>
  </body>

</html>
EOF

printf 'Created posts/%s\n' "$FILENAME"