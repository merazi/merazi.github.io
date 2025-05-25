#!/bin/bash

POSTS_DIR="posts"
OUTPUT_FILE="posts.json"

echo "[" > "$OUTPUT_FILE"

first=true
for file in "$POSTS_DIR"/*.html; do
    # Extract the title from the <title> tag
    title=$(grep -m1 -oP '(?<=<title>).*?(?=</title>)' "$file")

    # Skip files with no title
    if [[ -z "$title" ]]; then
        continue
    fi

    # Add comma if this is not the first entry
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    # Extract the src from the <img class="post-picture" src="...">
    picture=$(grep -oP '<img[^>]+class="post-picture"[^>]+src="\K[^"]+' "$file" | head -n1)

    # Write the JSON object
    echo "    {" >> "$OUTPUT_FILE"
    echo "        \"title\": \"$title\"," >> "$OUTPUT_FILE"
    echo "        \"file\": \"$file\"," >> "$OUTPUT_FILE"
    echo "        \"picture\": \"$picture\"" >> "$OUTPUT_FILE"
    echo -n "    }" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo "✅ posts.json generated!"
