let element = document.createElement("link");
element.setAttribute("rel", "stylesheet");
element.setAttribute("href", "../static/fonts/style.css");
document.head.appendChild(element);

element = document.createElement("link");
element.setAttribute("rel", "stylesheet");
element.setAttribute("href", "../static/style.css");
document.head.appendChild(element);

element = document.createElement("script");
element.src = "../static/fonts/script.js";
document.body.appendChild(element);

element = document.createElement("script");
element.src = "../static/script.js";
document.body.appendChild(element);
