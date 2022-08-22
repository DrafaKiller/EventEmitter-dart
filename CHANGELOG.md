## 0.5.0

**`[!]`** Removed:
* Redundant `listener` reference of itself, in  **EventListener** callbacks: `onAdd`, `onRemove`, `onCall` and `onCancel`. For simplicity and to avoid `dynamic` listener type issues. Use `this` if possible, or a reference of the listener instead.

Fixed:
* **EventListener** callbacks documentation
* Main example

## 0.4.5

Fixed:
* `.emit()` returns satisfaction

## 0.4.4

Added:
* **EventListener** property `dataType`

Fixed:
* Improved data type validation for `dynamic` data

## 0.4.3

Added:
* **StreamEventListener**, it's useful for having a streaming alternative to the default **EventEmitter** class

Fixed:
* Documentation with old property `topic` naming
* **EventListener** callbacks would throw an exception in some cases when using dynamic

## 0.4.2

Added:
* `cancelAdded` parameter to **EventListener**, tells the listener to automatically remove itself from the added **EventEmitter** when the `.cancel()` method is called. This is used in case you want to add your own canceling method. It essentially appends callbacks to the `onCancel` callbacks.

* `.appendCallback()` method to **EventListener**

**`[!]`** Changed:
* Typedef **EventAddedCallback** renamed to **EventCallbackAdd**
* Typedef **EventRemoveCallback** renamed to **EventCallbackRemove**
* Typedef **EventCancelCallback** renamed to **EventCallbackCancel**

Fixed:
* `lint` dependency moved to developer dependency

## 0.4.1

Changed:
* `rxdart` dependency updated from `0.27.3` to `0.27.5`

Fixed:
* Type matching in `.off()`
* **`[!]`** Positional parameters in `.off()` changed to named parameters, as it was intended

## 0.4.0

Added:
* **EventListener** properties `once` and `protected` added
* **EventListener** callbacks `onAdd`, `onRemove` and `onCancel`
* **EventListener** handles custom events, they can also act like normal events. This is used to add context to an event if needed.
* **EventEmitter** `.on()` can catch the data as well as the **Event\<T>** of the data

**`[!]`** Changed:
* **EventStreamEmitter** was renamed to **StreamEventEmitter**
* **Event** property **topic** renamed to **type**, to match JavaScript events
* **Event** property **message** renamed to **data**
* **StreamEventEmitter**'s stream controller is now public

**`[!]`** Removed:
* **EventEmitter** sync
* **EventListener** property `stream`, `subscription` and `messageType`

Massive BREAKING CHANGES:
* **EventEmitter** was refactored to not depend on Streams, which means it now manages the callbacks itself. The emitter can have more complex listener logic. Before it would depend on **StreamEventEmitter**.

* File structure was changed to be more organized. This means you might need to update your imports.

* Sync is no longer a thing in the **EventEmitter**, it's a **StreamEventEmitter** only thing now.

* Other changes: **`[!]`**

## 0.3.1

Added:
* `shield.io` badges

Changed:
* ChangeLog's format

## 0.3.0

Changed:
* `.onAny` in `EventEmitter` now returns an `EventListener`

Fixed:
* In some cases, canceled listeners didn't get removed, now it's more accurate

## 0.2.1

Fixed:
* Make package only `dart` dependant

## 0.2.0

Added:
*  `.emitEvent()` emits an existing event, without having to create a new one 

## 0.1.0

Added:
* `rxdart` package dependency, for better-implemented streams

Fixed:
* Cast with `dynamic` type would break unexpectedly

## 0.0.7

Fixed:
* `.onAny` return type (Still has errors)

## 0.0.6

Changed: 
* Filter `.onAny<T>()` by type

Fixed: 
* `pubspec.yaml` clean up
* Example with `final`

## 0.0.5+2

Changed:
* Package description and documentation for type safety promotion

## 0.0.5+1

Added:
* More documentation (Why is this package different?)

Fixed:
* Documentation typos

## 0.0.5

Changed:
* `once` in `EventEmitter` now returns a `Future` with the message, allowing to `await` (still needs a callback)
* Separated `EventEmitter` and `EventStreamEmitter` classes into different files
* Internal variable names for simplification


Removed:
* `send` for simplification, the same could be achieved with `emit`

## 0.0.4

Removed:
* Package dependency `flutter_lints`

## 0.0.3

Fixed:
* StreamSubscription, cancel instances

## 0.0.2

Changed:
* `on` to return an EventListener, instead of a StreamSubscription

Fixed:
* Package description (was too long)

## 0.0.1

Initial release: EventEmitter