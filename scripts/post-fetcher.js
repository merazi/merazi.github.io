fetch('posts.json')
    .then(response => response.json())
    .then(posts => {
        const container = document.querySelector('.post');
        posts.forEach(post => {
            const div = document.createElement('div');
            div.className = 'post fade-in';
            div.innerHTML = `
                <div class="flex items-center h-32">
                    <img src="${post.picture}" alt="${post.title}" class="post-image w-32 h-32 mr-4 object-cover block rounded" />
                    <div class="flex flex-col justify-center h-full">
                        <h2 class="text-xl font-semibold mb-2">${post.title}</h2>
                        <p>
                            <a href="${post.file}" class="inline-block px-4 py-2 mt-2 text-white bg-blue-600 rounded hover:bg-blue-700 transition-colors duration-200 shadow">
                                Read Blog Post
                            </a>
                        </p>
                    </div>
                </div>
            `;
            container.appendChild(div);
            observer.observe(div); // apply fade-in
        });
    });