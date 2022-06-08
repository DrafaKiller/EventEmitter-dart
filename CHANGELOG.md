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