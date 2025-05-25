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
                <div style="display: flex; gap: 8px; margin-top: 8px;">
                    <a href="${post.url}" target="_blank" style="padding: 8px 16px; background: #007bff; color: #fff; border: none; border-radius: 4px; text-decoration: none; display: inline-block;">Go to project</a>
                    <a href="${post.source}" target="_blank" style="padding: 8px 16px; background: #6c757d; color: #fff; border: none; border-radius: 4px; text-decoration: none; display: inline-block;">View source</a>
                </div>
                <br>
            `;
            container.appendChild(div);
            observer.observe(div); // apply fade-in
        });
    });