import os
type("Create VMPlayer OVA Image ...")
myApp = App.open("vmplayer")
wait(10)
#myApp = App.focusedWindow()
#wait(5)
click("1423856528091.png")

click("1423607580887.png")
wait(2)
click("1423838877826.png")
click("1423837876682.png")
type(os.environ['VM_DIR']+"\n")
click("1423839629547.png")

click("1423838758674.png")

click("1423839652363.png")
wait(5)
click("1423839673475.png")

wait("1424183499510.png",120)

run(os.environ['VMX_SCRIPT_DIR']+"/create_ova.sh")

#wait(10)
#focus()
#wait(5)
click("1424183499510.png")
wait(2)
rightClick("1423860347901.png")
wait(2)

click("1424183595662.png")
wait(2)
click("1423859264388.png")

waitVanish("1424183499510.png",20)


myApp.close()
wait(2)


type("DONE")