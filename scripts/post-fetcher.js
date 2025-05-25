fetch('posts.json')
    .then(response => response.json())
    .then(posts => {
        const container = document.querySelector('.container');
        posts.forEach(post => {
            const div = document.createElement('div');
            div.className = 'post fade-in';
            div.innerHTML = `
                <div style="display: flex; align-items: center; height: 128px;">
                    <img src="${post.picture}" alt="${post.title}" class="post-image" width="128" height="128" style="margin-right: 16px; object-fit: cover; display: block;">
                    <div style="display: flex; flex-direction: column; justify-content: center; height: 100%;">
                        <h2>${post.title}</h2>
                        <p><a href="${post.file}">Read Blog Post</a></p>
                    </div>
                </div>
            `;
            container.appendChild(div);
            observer.observe(div); // apply fade-in
        });
    });