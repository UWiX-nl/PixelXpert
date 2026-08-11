Took the Magisk PixelXpert Canary v499 from here:
https://github.com/siavash79/PixelXpert

A great extra settings module on Google Pixel with Android 17. But the app will not start because of root-check-failure.

This is the same Magisk flashable .zip with the root checks stripped out. 
Be sure LSPosed is activated for the PixelXpert after installing. Also be sure to reboot after first install. 
The first time it starts it will close and restart, I will try to fix that later. But everything works fine on the tested Pixel 10.

I have to be honest: I am not an Android developer. I used the "force" of AI to change the "troubled" module. The original sourcecode is used from the link at the top of this readme.

## Important Context
These source folders "apk_work" and  "module_work" are not the original upstream source tree(s).
It is a prepared artifact folder based on:
- an extracted Magisk module zip
- an extracted APK
- local patching work done to bypass the app's root-service startup checks

