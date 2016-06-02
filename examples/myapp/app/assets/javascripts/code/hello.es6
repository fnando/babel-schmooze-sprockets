export default function hello() {
  const content = `
    Hello there from ES6/ES2015.
    This message was added by app/assets/javascripts/code/hello.es6.
  `;
  document.querySelector("#application").textContent = content;
}
