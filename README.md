# f_link

f_link is a Flutter wrapper of [abl_link](https://github.com/Ableton/link/tree/master/extensions/abl_link), which
is a C 11 wrapper made by Ableton for their C++ codebase.
This library attempts to be unopinionated and plain in
copying the functionality of abl_link, while providing some high level safeties and conveniences.

[Ableton Link](http://ableton.github.io/link) is a technology that synchronizes musical beat, tempo,
phase, and start/stop commands across multiple applications running
on one or more devices. Applications on devices connected to a local
network discover each other automatically and form a musical session
in which each participant can perform independently: anyone can start
or stop while still staying in time. Anyone can change the tempo, the
others will follow. Anyone can join or leave without disrupting the session.

## Implementation

- f_link currently wraps around all functions available in ['abl_link.h'](https://github.com/Ableton/link/blob/master/extensions/abl_link/include/abl_link.h) and makes them publicly available, except for the destructors, which are implemented with [NativeFinalizer](https://api.dart.dev/stable/2.18.2/dart-ffi/NativeFinalizer-class.html).
- Functions have been implemented as methods on either the `AblLink` or the `SessionState` struct depending on which of the two the original C function uses as a primary parameter and what seemed to be the most intuitive.
- At this point, handling thread and realtime safety with Audio and App Session States is left up to the user, just like in the original library.
- Ableton's documentation should mostly still apply to this library, since implementations have been copied as they were.
- The function documentation has been mostly copied from 'abl_link.h'.
- Currently, callbacks have been omitted from this library (see Known Issues).

## Known Issues

### No iOS and MacOS support yet

Flutter uses Cocoapods and Xcode instead of CMake as build system for iOS and MacOS. Ableton also provides a different SDK for iOS, called [LinkKit](https://github.com/Ableton/LinkKit), which uses a different API to [Link](https://github.com/Ableton/link). Potentially, this library can wrap around both LinkKit and Link in the future.

### Destructors

NativeFinalizer should reliably destroy the native objects attached to AblLink and SessionState instances when they leave the current scope and become inaccessible. More investigations are needed into the memory used by C++, to check for memory leaks.

### Registering callbacks with native code

Callbacks are not implemented yet. Native callbacks are difficult to implement into the Dart event loop. Currently they could only safely be done with native ports, which I may attempt at some point. See this Issue for more details: https://github.com/dart-lang/sdk/issues/37022 . At this point the user has to implement a polling solutions instead of relying on callbacks (see Example).

### Example

The example does not have audio yet. Audio probably has to be implemented on a seperate isolate to maintain sync and prevent blocking.

## Feedback

Pull requests and feedback in the discussions section is very welcome!
