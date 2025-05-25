#!/bin/bash

# Prompt for filename and title
read -p "Enter a short name for the post (e.g. my-first-post): " raw_filename
read -p "Enter post title: " title
read -p "Enter picture URL (optional, press Enter to skip): " picture

# Get current date
DATE=$(date +"%Y-%m-%d")

# Construct final filename
filename="${DATE}-${raw_filename}"
POSTS_DIR="posts"
FILE_PATH="$POSTS_DIR/$filename.html"

# Create the post file with content
cat > "$FILE_PATH" <<EOF
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>$title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="../css/main-style.css">
    <link rel="stylesheet" href="../css/post-style.css">
</head>

<body>

    <img class="post-picture" src="$picture" alt="hidden image" style="display:none;">

    <nav>
        <a href="../index.html" style="text-decoration:none;color:#3498db;font-weight:bold;">&larr; Back to Home</a>
    </nav>

    <div class="post">
        <h1>$title</h1>
        <div class="meta">$DATE</div>
        <div class="post-content">

            <p>
                Welcome to my new blog! This is a sample post to get things started.
                Here you can share your thoughts, ideas, and stories with the world.
            </p>

        </div>
    </div>
</body>

</html>
EOF

echo "✅ New blog post created at: $FILE_PATH"

# Run JSON generator
if [ -f "./generate_posts_json.sh" ]; then
    ./generate_posts_json.sh
    echo "🛠️  Updated posts.json with the new post!"
else
    echo "⚠️  Warning: generate_posts_json.sh not found. Skipping JSON update."
fi

code $FILE_PATH
