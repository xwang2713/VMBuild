type("Import an ova to vmplayer")
App.open("\"C:\\Program Files (x86)\\VMware\\VMware Player\\vmplayer.exe\"\n")
wait(5)
myApp=App.focusedWindow()
wait(5)
click("1432304729759.png")

click("1432305006665.png")
wait(2)
click("1432305198879.png")
click("1432305896070.png")
type("C:/tmp/VMs\n")
click("1423839629547.png")

click("1423838758674.png")

click("1423839652363.png")
wait(5)
click("1423839673475.png")
wait(120)

#run("/home/xwang/work/shell/sed/update_vhw.sh")

#wait(10)
myApp.focus()
wait(5)
click("1423860316709.png")
rightClick("1423860347901.png")


click("1423859237540.png")
click("1423859264388.png")
wait(5)







type("DONE")