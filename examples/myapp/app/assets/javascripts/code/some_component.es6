export default class SomeComponent {
  construct(target) {
    target.on("ready", ::this.onReady);
  }

  onReady() {

  }
}
