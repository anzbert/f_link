[![pub_package](https://img.shields.io/pub/v/f_link.svg?color=blue)](https://pub.dartlang.org/packages/f_link)

# f_link

f_link is a Flutter wrapper of [abl_link](https://github.com/Ableton/link/tree/master/extensions/abl_link), which is a C 11 extension made by Ableton for their C++ codebase.
This library attempts to be unopinionated and plain in
copying the functionality of abl_link, while providing some high level convenience and safety.

[Ableton Link](https://ableton.github.io/link) is a technology that synchronizes musical beat, tempo,
phase, and start/stop commands across multiple applications running
on one or more devices. Applications on devices connected to a local
network discover each other automatically and form a musical session
in which each participant can perform independently: anyone can start
or stop while still staying in time. Anyone can change the tempo, the
others will follow. Anyone can join or leave without disrupting the session.

## Usage

### Android

Android apps must declare their use of the network in the Android manifest in `android/src/main/AndroidManifest.xml`. Add this permission request inside the `<manifest>` scope:

```
<uses-permission android:name="android.permission.INTERNET" />
```

### MacOS

Requires entitlements to be set to give the app network usage permissions. Add this key to `macos/Runner/DebugProfile.entitlements` and to `macos/Runner/Release.entitlements`:

```
<key>com.apple.security.network.client</key>
<true/>
```

## Implementation

- f_link currently wraps around all functions available in ['abl_link.h'](https://github.com/Ableton/link/blob/master/extensions/abl_link/include/abl_link.h) and makes them publicly available. The destructors are implemented with [NativeFinalizer](https://api.dart.dev/stable/2.18.2/dart-ffi/NativeFinalizer-class.html), which should make manually destroying instances and freeing memory unnecessary.
- Function documentation has been copied almost 1:1 from 'abl_link.h' as it should still apply.
- Functions have been implemented as methods on either the `AblLink` or the `SessionState` struct depending on which of the two the original C function uses as a primary parameter and what seemed to be the most intuitive.
- At this point, handling thread and realtime safety with Audio and App SessionStates is left up to the user, just like in the original library.
- Callbacks have been omitted from this library (see Known Issues).

## Known Issues

### No iOS support yet

Ableton provides a different SDK for iOS, called [LinkKit](https://github.com/Ableton/LinkKit), which uses a different API to [Link](https://github.com/Ableton/link). Potentially, this library could wrap around both LinkKit and Link in the future.

### Registering callbacks with native code

Callbacks are not implemented yet. Native callbacks are difficult to implement into the Dart event loop. Currently they could only safely be done with native ports, which I may attempt at some point. See this Issue for more details: https://github.com/dart-lang/sdk/issues/37022 . At this point the user has to implement a polling solutions instead of relying on callbacks (see Example).

### Destructors

NativeFinalizer should reliably destroy the native objects attached to AblLink and SessionState instances when they leave the current scope and become inaccessible. More investigations may be needed into the memory used by C++, to check if that reliably happens.

### Example

The example does not have audio yet. Audio likely will need to be implemented on a seperate isolate to maintain sync and prevent blocking.

## Feedback

Pull requests and feedback in the discussions section is very welcome!

## License

Ableton Link is dual licensed under GPLv2+ and a proprietary [license](https://github.com/Ableton/link/blob/master/LICENSE.md).

This means that this wrapper is automatically under the GPLv2+ as well. A copy of the license is distributed with the source code.

If you would like to incorporate Link into a proprietary software application, please contact Ableton at <link-devs@ableton.com>.

## Links

I also made an Ableton Link wrapper for Rust, called [rusty_link](https://crates.io/crates/rusty_link), to learn about FFI wrapping before making this plugin.
