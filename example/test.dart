class Event<T> {}
class Listener<T extends Event> {}
class Subscription<T extends Event> extends Listener<Event<T>> {}