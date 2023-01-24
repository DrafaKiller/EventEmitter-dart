class Event<T> {

}

mixin Test {

}

extension <T> on T {
  Event<T> get event => Event<T>();
}

extension <T extends Event> on Event {
  T get event => this;
}
