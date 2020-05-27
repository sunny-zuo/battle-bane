# Battle Bane

Battle Bane is a top down multiplayer shooter game built for Adobe Flash (desktop) and Adobe AIR (mobile). It utilizes a [simple websocket echo server](https://github.com/sunny-zuo/ws-echo-server) to run and supports cross-play between desktop and mobile clients. The codebase for both versions are largely similar, with only slight modifications to the control scheme.

### Features
- Online multiplayer
- Cross-play between mobile and desktop clients
- Keyboard + Mouse controls on desktop, double joystick on mobile
- Customizable stats with skill point system
- Settings persist across sessions
- Pixel perfect collision detection
- Freely drawable game map

### Libraries
- Uses mesmotronic's [air-ane-fullscreen](https://github.com/mesmotronic/air-ane-fullscreen) ANE for full screen on Android
- Uses hurlant's [AS3 Cryptography framework](http://crypto.hurlant.com/)
- Uses worlize's websocket
