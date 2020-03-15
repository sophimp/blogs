for (( i=0; i<1600; i++ ))
do
	adb shell input tap 350 1365
	sleep 2
	adb shell input tap 355 1365
	sleep 2

	sleep 5
	for (( i=0; i<6; i++))
	do
		sleep 6
		adb shell input tap 300 1900
		sleep 6
		adb shell input tap 525 1900
		sleep 6
		adb shell input tap 700 1900
		sleep 6
		adb shell input tap 880 1900
	done

	sleep 5

	#adb shell input tap 750 1400

	#adb shell input tap 550 1650

done
