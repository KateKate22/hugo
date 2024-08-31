const listBlockquote = document.querySelectorAll('blockquote');
listBlockquote && listBlockquote.forEach((item) => item.classList.add('blockquote'));

// srcrollSpy для содержания
const tableOfContents = document.querySelector('#TableOfContents');
if (tableOfContents) {
    const listGroup = tableOfContents.querySelector('ul');
    listGroup && listGroup.classList.add('nav', 'flex-column');
    const listItemListGroup = listGroup.querySelectorAll('li');
    listItemListGroup &&
        listItemListGroup.forEach((item) => {
            item.classList.add('nav-item');
            const link = item.querySelector('a');
            link && link.classList.add('nav-link');
        });
}

const scrollSpy = new bootstrap.ScrollSpy(document.body, {
    target: '#TableOfContents',
});

// Увеличение изображений
const listImages = document.querySelectorAll('img');
if (listImages.length) {
    mediumZoom(listImages);
    hljs.initHighlightingOnLoad();
}
