#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
POSTS_DIR="$ROOT_DIR/posts"
FEED_FILE="${FEED_FILE:-$ROOT_DIR/feed.xml}"
SITE_URL="${SITE_URL:-https://merazi.github.io}"
SITE_URL=${SITE_URL%/}

xml_escape() {
    sed \
        -e 's/&/\&amp;/g' \
        -e 's/</\&lt;/g' \
        -e 's/>/\&gt;/g' \
        -e 's/"/\&quot;/g' \
        -e "s/'/\&apos;/g"
}

html_text() {
    perl -0pe 's/<[^>]*>//g; s/\s+/ /g; s/^\s+|\s+$//g'
}

post_title() {
    perl -0777 -ne 'if (/<h1\b[^>]*>(.*?)<\/h1>/is) { print $1; exit }' "$1" | html_text
}

post_description() {
    perl -0777 -ne 'if (/<p\b[^>]*>(.*?)<\/p>/is) { print $1; exit }' "$1" | html_text
}

post_date() {
    local post_file=$1
    local date_value

    date_value=$(perl -0777 -ne '
        if (/<time\b[^>]*\bdatetime=["\x27]([^"\x27]+)["\x27][^>]*>/is) { print $1; exit }
        if (/<meta\b[^>]*(?:name|property)=["\x27](?:date|published)["\x27][^>]*\bcontent=["\x27]([^"\x27]+)["\x27]/is) { print $1; exit }
    ' "$post_file")

    if [[ -z $date_value && $(basename "$post_file") =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})- ]]; then
        date_value=${BASH_REMATCH[1]}
    fi

    if [[ -z $date_value && -d "$ROOT_DIR/.git" ]]; then
        date_value=$(git -C "$ROOT_DIR" log -1 --format='%aI' -- "${post_file#"$ROOT_DIR/"}" || true)
    fi

    if [[ -z $date_value ]]; then
        date_value=$(stat -c '%y' "$post_file")
    fi

    date -u -d "$date_value" '+%a, %d %b %Y %H:%M:%S GMT'
}

if [[ ! -d $POSTS_DIR ]]; then
    printf 'Posts directory not found: %s\n' "$POSTS_DIR" >&2
    exit 1
fi

mapfile -t post_files < <(find "$POSTS_DIR" -maxdepth 1 -type f -name '*.html' -print | sort -r)

tmp_file=$(mktemp "${FEED_FILE}.XXXXXX")
trap 'rm -f "$tmp_file"' EXIT

{
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
        <title>Merazi's webpage</title>
        <link>${SITE_URL}/</link>
        <description>Posts from Merazi's webpage</description>
        <language>en-us</language>
        <atom:link href="${SITE_URL}/feed.xml" rel="self" type="application/rss+xml" />
EOF

    for post_file in "${post_files[@]}"; do
        relative_path=${post_file#"$ROOT_DIR/"}
        post_url="$SITE_URL/${relative_path//\\//}"
        title=$(post_title "$post_file")
        description=$(post_description "$post_file")
        published=$(post_date "$post_file")

        if [[ -z $title ]]; then
            printf 'Could not find an h1 title in %s\n' "$relative_path" >&2
            exit 1
        fi

        title=$(printf '%s' "$title" | xml_escape)
        description=$(printf '%s' "$description" | xml_escape)

        cat <<EOF

        <item>
            <title>${title}</title>
            <link>${post_url}</link>
            <guid isPermaLink="true">${post_url}</guid>
            <pubDate>${published}</pubDate>
            <description>${description}</description>
        </item>
EOF
    done

    cat <<EOF
    </channel>
</rss>
EOF
} > "$tmp_file"

mv -- "$tmp_file" "$FEED_FILE"
trap - EXIT
printf 'Generated %s from %d post(s).\n' "$FEED_FILE" "${#post_files[@]}"
