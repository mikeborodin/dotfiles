set -e
ip=`adb shell ifconfig wlan0 | awk '/inet /{print $2}' | cut -d':' -f2`

adb tcpip 5555

adb connect "$ip:5555"
