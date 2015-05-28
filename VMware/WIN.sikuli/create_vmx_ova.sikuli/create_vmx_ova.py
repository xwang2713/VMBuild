import os
type("Create VMPlayer OVA Image ...")
myApp = App.open("\"C:\\Program Files (x86)\\VMware\\VMware Player\\vmplayer.exe\"\n")
wait(5)
#App.focusedWindow()
#wait(5)
click("1432310130752.png")

click("1432310344672.png")
wait(2)

click("1432310519982.png")
type(os.environ['VM_DIR']+"\n")
click("1432316009889.png")

click("1432316141935.png")

click("1432316077260.png")

wait(5)
if exists("1423839673475.png"):
  click("1423839673475.png")

wait("1432317353122.png",160)

run(os.environ['SCRIPT_DIR']+"/create_ova.cmd")

#wait(10)
#focus()
#wait(5)

click("1432317353122.png")
wait(2)
rightClick("1432317353122.png")
wait(2)

click("1432325271792.png")
wait(2)
click("1432330682227.png")

waitVanish("1432317353122.png",20)

myApp.close()
wait(2)


type("DONE")