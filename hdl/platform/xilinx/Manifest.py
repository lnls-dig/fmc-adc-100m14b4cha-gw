files = ["platform_specific_pkg.vhd"]

if (target == "xilinx" and syn_device[0:4].upper()=="XC6S"):
    modules = {"local" : ["spartan6"]}
elif (target == "xilinx" and syn_device[0:4].upper()=="XC6V"):
	modules = {"local" : ["virtex6"]}
elif (target == "xilinx" and syn_device[0:3].upper()=="XC7"):
	modules = {"local" : ["series7"]}
else:
    print ("WARNING: FPGA family not supported. Some functionality might be unavailable")
