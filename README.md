# f_link

f_link is a Flutter wrapper of [abl_link](https://github.com/Ableton/link/tree/master/extensions/abl_link), which
is a C 11 wrapper made by Ableton for their C++ codebase.
This library attempts to be unopinionated and plain in
copying the functionality of abl_link, while providing some high level safeties.

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
- The function documentations have been copied from 'abl_link.h'.
- Currently, the callbacks have been omitted from the implementation and the user has to poll the current state instead (see Known Issues).

## Known Issues

### No iOS and MacOS support yet

Flutter uses Cocoapods and Xcode instead of CMake as build system for iOS and MacOS. Ableton also provides a different SDK for iOS, called [LinkKit](https://github.com/Ableton/LinkKit), which uses a different API to [Link](https://github.com/Ableton/link).

### Destructors

NativeFinalizers seem to work to destroy AblLink and SessionState Objects when they leave the current scope. Making these objects nullable (like AblLink?) variables seemed to interfere with reliable destruction. More investigations are needed into C++ memory management ,which happens behind the scenes.

### Registering callbacks with native code

Callbacks not implemented yet. Native callbacks are difficult to implement into the Dart event loop. Currently they could only safely be done with native ports, which I may attempt at some point. See Issue for more details: https://github.com/dart-lang/sdk/issues/37022
