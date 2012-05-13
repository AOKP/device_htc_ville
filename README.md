android_device_htc_ville
========================

Android device tree for HTC Ville (One S)

Build requirements:
* frameworks/base, branch ics-ville
* hardware/alsa_sound, branch ics-chocolate
* system/bluetooth, branch ics-ville
* vendor/qcom/opensource/kernel-tests/libalsa-intf, branch ics-chocolate

Working:
* Bluetooth
* Camera
* Radio
* Sound
* Wifi

Known issues:
* Camera crashes when changing from front to main
* Data state changes may not always acquire IP via DHCP
* Wifi tethering does not work
* Wifi calling not available
* Camcorder does not initialize properly
* Radio DHCP fails when switching to 2G
