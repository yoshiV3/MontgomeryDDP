sdk setws project_sw
sdk createhw -name hw_platform -hwspec hwdef.hdf
sdk createbsp -name hw_bsp -hwproject hw_platform -proc ps7_cortexa9_0 -os standalone
sdk createapp -name sw_design -hwproject hw_platform -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp hw_bsp