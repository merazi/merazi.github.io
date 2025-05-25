fetch('projects.json')
    .then(response => response.json())
    .then(posts => {
        const container = document.querySelector('.sidebar');
        posts.forEach(post => {
            const div = document.createElement('div');
            div.className = 'post fade-in';
            div.innerHTML = `
                <div style="display: flex; align-items: center;">
                    <img src="${post.icon}" width="32" height="32" style="width:32px; height:32px; margin-right: 8px;" />
                    <h2 style="margin: 0;">${post.title}</h2>
                </div>
                <p>${post.description}</p>
                <p><a href="${post.url}" target="_blank">Go to project</a></p>
            `;
            container.appendChild(div);
            observer.observe(div); // apply fade-in
        });
    });