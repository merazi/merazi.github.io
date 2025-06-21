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
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 text-gray-900 min-h-screen">

    <img class="hidden" src="$picture" alt="hidden image">

    <nav class="p-4">
        <a href="../index.html" class="text-blue-600 font-semibold hover:underline flex items-center">
            &larr; Back to Home
        </a>
    </nav>

    <div class="max-w-2xl mx-auto bg-white shadow-md rounded-lg p-8 mt-8">
        <h1 class="text-3xl font-bold mb-2">$title</h1>
        <div class="text-sm text-gray-500 mb-6">$DATE</div>
        <div class="prose prose-lg max-w-none post-content">

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
