fetch('posts.json')
    .then(response => response.json())
    .then(posts => {
        const container = document.querySelector('.container');
        posts.forEach(post => {
            const div = document.createElement('div');
            div.className = 'post fade-in';
            div.innerHTML = `
                    <h2>${post.title}</h2>
                    <p><a href="${post.file}" >Read Blog Post</a></p>
                `;
            container.appendChild(div);
            observer.observe(div); // apply fade-in
        });
    });