#!/system/bin/sh
#
# Project Atomic's by the kazuyoo
# Created NR By @KazuyooOpenSources
# open-source loving GL-DP and all contributors;
# System Properties Which has been adjusted so that the app runs more perfectly and is responsive.
#

# // Sync to data in the rare case a device crashes
sync

# // Path & Array
MODDIR=/sdcard/Kazu
NAME="Project Atomic's | Kzyo"
VERSION="1.0 Revolt"
ANDROIDVERSION=$(getprop ro.build.version.release)
DATE="Mon 22 Jul 2024"
DEVICES=$(getprop ro.product.board)
MANUFACTURER=$(getprop ro.product.manufacturer)
API=$(getprop ro.build.version.sdk )
SETPROP=$(getprop debug.performance.tuning)
CMD=$(cmd settings get system log_cmd_power)
THERMAL=$(cmd settings get system log_thermalservice)
COMPOSIT=$(getprop debug.composition.type)
RENDER=$(getprop debug.hwui.renderer)
MEMORY=$(am memory-factor show)
COMPILE=$(cmd settings get system log_compile)
FSTRIM=$(cmd settings get global fstrim_mandatory_interval)

# Flash Repeat
repeat() {
    sh $MODDIR/run.sh
}

# // set debug
set_debug_prop() {
    setprop debug.$1 "$2"
}
    
# // insert debug prop
menu_properties() {
while true; do
    clear
    echo -e
	  sleep 0.1
	  echo -e "- Patching Set Debug Prop..."
  	sleep 5
    echo -e "- done...\n"
    
# Disable Anti-Aliasing
    set_debug_prop "egl.force_msaa" false
    set_debug_prop "egl.force_fxaa" false
    set_debug_prop "egl.force_taa" false
    set_debug_prop "egl.force_ssaa" false
    set_debug_prop "egl.force_smaa" false

# Hwui
    set_debug_prop "hwui.skip_empty_damage" true
    set_debug_prop "hwui.use_buffer_age" true
    set_debug_prop "hwui.use_gpu_pixel_buffers" 1
    set_debug_prop "hwui.skia_use_perfetto_track_events" false
    set_debug_prop "hwui.skia_tracing_enabled" false
    set_debug_prop "hwui.skia_atrace_enabled" true
    set_debug_prop "hwui.app_memory_policy" aggresive

# Disable Overlay
    set_debug_prop "sf.ddms" 0
    set_debug_prop "sf.showfps" 0
    set_debug_prop "sf.showcpu" 0
    set_debug_prop "sf.showbackground" 0
    set_debug_prop "sf.shoupdates" 0

# Gralloc
    set_debug_prop "gralloc.gfx_ubwc_disable" 0

# Fps
    set_debug_prop "choreographer.skipwarning" 30
    set_debug_prop "choreographer.frametime" false
    set_debug_prop "hwui.fps_divisor" -1

# Network
    set_debug_prop "hw_fast_dormancy" 1

# Performance Tuning
    set_debug_prop "performance.tuning" 1

# Surface Flinger
    set_debug_prop "sf.use_phase_offsets_as_durations" 1
    set_debug_prop "sf.predict_hwc_composition_strategy" 0
    set_debug_prop "sf.enable_transaction_tracing" false
    set_debug_prop "sf.enable_gl_backpressure" 1
    set_debug_prop "sf.disable_backpressure" 1
    set_debug_prop "sf.hw" 0
    set_debug_prop "sf.latch_unsignaled" 0
    set_debug_prop "sf.auto_latch_unsignaled" false

# Other
    set_debug_prop "stagefright.c2inputsurface" 1
    set_debug_prop "stagefright.ccodec" 4
    set_debug_prop "stagefright.omx_default_rank" 0
    set_debug_prop "atrace.tags.enableflags" 0
    set_debug_prop "power.monitor_tools" false
    set_debug_prop "kill_allocating_task" 0
    set_debug_prop "gr.numframebuffers" 3
    set_debug_prop "egl.hw" 0
    set_debug_prop "egl.profiler" 0

    sleep 0.1
    echo -n " Use enter for main menu : "
    read selected_prompt
	clear
case $selected_prompt in
    esac
    clear && break
    repeat
done
}

# // menu cmd power
cmd_Power() {
 while true; do
    clear
    echo -e ""
    echo -e "[ ! ] Use enter for main menu\n"
	echo -e "- Menu For Cmd Power : "
	echo -e "1. Power Adaptive\n  enables adaptive power saver.\n2. Power Saver\n  sets the power mode of the device to MODE.\n3. Power Performance\n  enables fixed performance mode\n4. Reset all Cmd Power\n  reset to all cmd power\n"
   echo -n "Select the Number : "
   
     power_Adaptive() {
     # Detect Value
        cmd settings put system log_cmd_power "1"
     # cmd which works below
        cmd power set-adaptive-power-saver-enabled "true"
     }
     power_Saver() {
     # Detect Value
        cmd settings put system log_cmd_power "1"
     # cmd which works below
        cmd power set-mode "1"
     }
     power_Perf() {
     if [ $API -ge 30 ]; then
     # Detect Value
        cmd settings put system log_cmd_power "1"
     # cmd which works below
        cmd power set-fixed-performance-mode-enabled "true"
     else
        echo -e ""
        echo -e "[ ! ] Unsupported API Version: $API" 
        sleep 5 && cmd_Power
     fi
        clear
     }
     reset_all() {
        cmd settings delete system log_cmd_power 
        cmd power set-adaptive-power-saver-enabled "false"
        cmd power set-mode "0"
        cmd power set-fixed-performance-mode-enabled "false"
     }
   read selected_prompt
	clear
	
  case $selected_prompt in
    1) power_Adaptive;;
	2) power_Saver;;
	3) power_Perf;;
	4) reset_all;;
    esac
		clear && break
        repeat
	done

}

# // menu composition type
composition_Type() {
 while true; do
    clear
    echo -e ""
	echo -e "[ ! ] Use enter for main menu\n"
	echo -e "- Menu For Composition Type : "
	echo -e "1. dyn\n  for cpu & gpu\n2. gpu\n  gpu only\n3. cpu\n  cpu only\n4. mdp\n  multi depth something [ buggy on xs ]\n5. c2d\n  core to duo [ kinda like dyn only more gpu use ]\n"
	echo -n "Select the Number : "
   
     dyn() {
        set_debug_prop "composition.type" dyn
     }
     gpu() {
        set_debug_prop "composition.type" gpu
     }
     cpu() {
        set_debug_prop "composition.type" cpu
     }
     mdp() {
        set_debug_prop "composition.type" mdp
     }
     c2d() {
        set_debug_prop "composition.type" c2d
     }
  read selected_prompt
	clear
	
  case $selected_prompt in
    1) dyn;;
	2) gpu;;
	3) cpu;;
	4) mdp;;
    5) c2d;;
    esac
		clear && break
        repeat
	done

}

# // menu thermal service
thermal_Service() {
 while true; do
    clear
    echo -e ""
    echo -e "[ ! ] Use enter for main menu\n"
	echo -e "- Menu For Thermal Service : "
	echo -e "0. None\n  no restrictions."
	echo -e "1. Light\n  light slowdown."
	echo -e "2. Moderate\n  moderate restrictions."
	echo -e "3. Severe\n  severe restrictions."
	echo -e "4. Critical\n  the platform has done everything to reduce power."
	echo -e "5. Emergency\n  Key components in the platform were shut down due\n  to thermal conditions and limited device functionality."
	echo -e "6. Shutdown\n  Turn it off immediately. Due to the severity of this stage, \n  the application may not be able to receive these notifications."
	echo -e "7. Reset\n  reset to thermal service default\n"
	echo -n "Select the Number : "
   
     none() {
        cmd settings put system log_thermalservice 0
        cmd thermalservice override-status "0"
     }
     light() {
        cmd settings put system log_thermalservice 1
        cmd thermalservice override-status "1"
     }
     moderate() {
        cmd settings put system log_thermalservice 2
        cmd thermalservice override-status "2"
     }
     severe() {
        cmd settings put system log_thermalservice 3
        cmd thermalservice override-status "3"
     }
     critical() {
        cmd settings put system log_thermalservice 4
        cmd thermalservice override-status "4"
     }
     emergency() {
        cmd settings put system log_thermalservice 5
        cmd thermalservice override-status "5"
     }
     shutdown() {
        cmd settings put system log_thermalservice 6
        cmd thermalservice override-status "6"
     }
     reset() {
        cmd settings delete system log_thermalservice
        cmd thermalservice reset
     }
  read selected_prompt
	clear
	
  case $selected_prompt in
    0) none;;
	1) light;;
	2) moderate;;
	3) severe;;
    4) critical;;
    5) emergency;;
    6) shutdown;;
    7) reset;;
    esac
		clear && break
        repeat
	done

}

# // menu renderer type
renderer_Type() {
 while true; do
    clear
    echo -e ""
	echo -e "[ ! ] Use enter for main menu"
	echo -e "        thanks for @zeta_zimp\n"
	echo -e "- Menu For Rendering Type : "
	echo -e "1. OpenGL\n  OpenGL [ Open Graphics Library ] is a cross-language, cross-platform\n  application programming interface [ API ] for rendering 2D and 3D\n  vector graphics.\n2. SkiaGL\n  Skia Graphics Engine or SkiaGL is a 2D graphics library\n3. Vulkan\n  Vulkan is a low-overhead, cross-platform graphics API, open\n  standard for 3D graphics and 3D computing.\n4. SkiaVK\n  Skia Graphics Engine or SkiaVK is a 2D graphics library\n"
	echo -n "Select the Number : "
   
     opengl() {
        set_debug_prop "stagefright.renderengine.backend" skiaglthreaded
        set_debug_prop "renderengine.backend" skiaglthreaded
        set_debug_prop "hwui.renderer" opengles
        set_debug_prop "xr.graphicsPlugin" OpenGLES
     }
     skiavk() {
        set_debug_prop "stagefright.renderengine.backend" skiavkthreaded
        set_debug_prop "renderengine.backend" skiavkthreaded
        set_debug_prop "hwui.renderer" skiavk
        set_debug_prop "xr.graphicsPlugin" SkiaVK
     }
     skiagl() {
        set_debug_prop "stagefright.renderengine.backend" skiaglthreaded
        set_debug_prop "renderengine.backend" skiaglthreaded
        set_debug_prop "hwui.renderer" skiagl
        set_debug_prop "xr.graphicsPlugin" SkiaGL
     }
     vulkan() {
        set_debug_prop "stagefright.renderengine.backend" skiavkthreaded
        set_debug_prop "renderengine.backend" skiavkthreaded
        set_debug_prop "hwui.use_vulkan_pipeline" 1
        set_debug_prop "hwui.renderer" vulkan
        set_debug_prop "xr.graphicsPlugin" Vulkan
     }
  read selected_prompt
	clear
	
  case $selected_prompt in
    1) opengl;;
	2) skiagl;;
	3) vulkan;;
	4) skiavk;;
    esac
		clear && break
        repeat
	done

}

# // menu memory factor
memory_Factor() {
 while true; do
    clear
    echo -e ""
    echo -e "[ ! ] Use enter for main menu\n"
	echo -e "- Menu For Memory-Factor : "
	echo -e "1. Critical\n  set the memory factor to a critical level.\n2. Low\n  set the memory factor to low level.\n3. Normal / Reset\n  set the memory factor to normal level.\n"
	echo -n "Select the Number : "
   
     critical() {
        am memory-factor set "CRITICAL"
     }
     low() {
        am memory-factor set "LOW"
     }
     normal() {
        am memory-factor set "NORMAL"
     }
  read selected_prompt
	clear
	
  case $selected_prompt in
    1) critical;;
	2) low;;
	3) normal;;
    esac
		clear && break
        repeat
	done

}

# // menu just in time or JIT
just_in_time() {
 while true; do
    clear
    echo -e ""
    echo -e "[ ! ] Use enter for main menu\n"
    echo -e "- Compiles 3rd applications, not system applications."
  	echo -e "- Menu For Just In Time Mode\nMODE is one of the dex2oat compiler filters : \n"
  	echo -e "1. Assume-Verified\n  the compiler is allowed to proceed with optimizations or\n  transformations based on unverified assumptions about code\n  correctness."
	  echo -e "2. Extract\n  the process in which certain parts of source code are\n  extracted during compilation for further use or analysis."
  	echo -e "3. Verify\n  the process by which the compiler checks and ensures that the\n  source code conforms to certain rules and specifications."
  	echo -e "4. Quicken\n  a compilation process designed to speed up code compilation."
  	echo -e "5. Space-Profile\n  a compilation process that collects information\n  about memory (space) usage by a program."
  	echo -e "6. Space\n  refers to the amount of memory used by the compiler\n  during the compilation process."
  	echo -e "7. Speed-Profile\n  a compilation process that collects data about\n  program execution performance."
  	echo -e "8. Speed\n  refers to the speed or time required by the\n  compiler to complete the compilation process."
  	echo -e "9. Everything\n  the process by which the entire source code of a project\n  is compiled, without exception."
  	echo -e "10. Everything-Profile\n  a compilation process that produces a performance profile\n  or analysis of a project's entire source code.\n"
    echo -n "Select the Number : "
   
     assume() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m assume-verified -f "$pkg"
        cmd settings put system log_compile assume-verified
     done
     }
     extract() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m extract -f "$pkg"
        cmd settings put system log_compile extarct
     done
     }
     verify() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m verify -f "$pkg"
        cmd settings put system log_compile verify
     done
     }
     quicken() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m quicken -f "$pkg"
        cmd settings put system log_compile quicken
     done
     }
     space_profile() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m space-profile -f "$pkg"
        cmd settings put system log_compile 
        space-profile
     done
     }
     space() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m space -f "$pkg"
        cmd settings put system log_compile space
     done
     }
     speed_profile() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m speed-profile -f "$pkg"
        cmd settings put system log_compile speed-profile
     done
     }
     speed() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m speed -f "$pkg"
        cmd settings put system log_compile speed
     done
     }
     everything() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m everything -f "$pkg"
        cmd settings put system log_compile everything
     done
     }
     everything_profile() {
     for pkg in $(cmd package list packages -3 | cut -f 2 -d ":"); do
        echo -e ""
        echo -e "[ ! ] Compiling $pkg"
        cmd package compile -m everything-profile -f "$pkg"
        cmd settings put system log_compile everything-profile
     done
        clear
     }
     check() {
     if $assume; $extract; $verify; $quicken; $space_profile; $space; $speed_profile; $speed; $everything; $everything_profile; then
        echo -e ""
     else
        echo -e ""
        echo -e "[ ! ] No games detected"
        sleep 5 && just_in_time
     fi
     }
   read selected_prompt
	clear
	
  case $selected_prompt in
    1) assume && check;;
	2) extract && check;;
	3) verify && check;;
	4) quicken && check;;
	5) space_profile && check;;
	6) space && check;;
	7) speed_profile && check;;
	8) speed && check;;
	9) everything && check;;
	10) everything_profile && check;;
    esac
		clear && break
        repeat
	done

}

# // menu fstrim
fstrim() {
 while true; do
    clear
    echo -e ""
    echo -e "[ ! ] Use enter for main menu"
    echo -e "        thanks for @tytydraco\n"
  	echo -e "- Menu For FStrim Tweaks : "
  	echo -e "1. Every Boot\n  Trim after rebooting.\n2. day\n  Trim after day.\n3. Other Day\n  Trim after other days.\n4. Three Days\n  Trim after three days.\n5. Week\n Trim after week.\n6. Month\n Trim after month.\n7. Reset\n Reset all trim.\n"
  	echo -n "Select the Number : "
   
     everyboot() {
        cmd settings put global fstrim_mandatory_interval 1
        sm fstrim
     }
     day() {
        cmd settings put global fstrim_mandatory_interval 86400000
        sm fstrim
     }
     other_day() {
        cmd settings put global fstrim_mandatory_interval 172800000
        sm fstrim
     }
     three_day() {
        cmd settings put global fstrim_mandatory_interval 259200000
        sm fstrim
     }
     week() {
        cmd settings put global fstrim_mandatory_interval 604800000
        sm fstrim
     }
     month() {
        cmd settings put global fstrim_mandatory_interval 2592000000
        sm fstrim
     }
     reset() {
        cmd settings put global fstrim_mandatory_interval 0
     }
  read selected_prompt
	clear
	
  case $selected_prompt in
    1) everyboot;;
	2) day;;
	3) other_day;;
	4) three_day;;
	5) week;;
	6) month;;
	7) reset;;
    esac
		clear && break
        repeat
	done

}

# menu donate
donate() {
 while true; do
    clear
    echo -e ""
    echo -e "[ ! ] Use enter for main menu\n"
  	echo -e "1. Go To Donate\n"
  	echo -n "Select the Number : "
   
     donate() {
        am start -a android.intent.action.VIEW -d https://sociabuzz.com/dikyganteng_/tribe
     }
  read selected_prompt
	clear
	
  case $selected_prompt in
    1) donate;;
    esac
		clear && break
        repeat
	done

}

# // menu choice or main menu
project_Atomic () {
    while true; do
          clear
      echo -e "\e[38;2;255;228;225m"
      sleep 0.2
      echo -e "░█▀▀█ ── ─█▀▀█ ▀▀█▀▀ ░█▀▀▀█ ░█▀▄▀█ ▀█▀ ░█▀▀█ █ ░█▀▀▀█ 
░█▄▄█ ▀▀ ░█▄▄█ ─░█── ░█──░█ ░█░█░█ ░█─ ░█─── ─ ─▀▀▀▄▄ 
░█─── ── ░█─░█ ─░█── ░█▄▄▄█ ░█──░█ ▄█▄ ░█▄▄█ ─ ░█▄▄▄█\n"
      echo -e "                     Simple Script For Tweaking\n"
      sleep 0.2
      echo -e "***************************************"
      echo -e "• Name            : ${NAME}"
      echo -e "• Version         : ${VERSION}"
      echo -e "• Android Version : ${ANDROIDVERSION}"
      echo -e "• Build Date      : ${DATE}"
      echo -e "***************************************"
      echo -e "• Devices         : ${DEVICES}"
      echo -e "• Manufacturer    : ${MANUFACTURER}"
      echo -e "***************************************\n"
      sleep 0.2
      echo -e "- Preparing Existing Tweak Features..\n"
      sleep 2
  	  echo -e "[ - ] P-Atomic's Tweak Menu 🍀"
      echo -e "1.Setprop Tweaks         : [${SETPROP}]"
      echo -e "2.Set Cmd Power          : [${CMD}]"
      echo -e "3.Thermal Service        : [${THERMAL}]"
      echo -e "4.Type Composition       : [${COMPOSIT}]"
      echo -e "5.Rendering Type         : [${RENDER}]"
      echo -e "6.Memory-Factor          : [${MEMORY}]"
      echo -e "7.Just In Time           : [${COMPILE}]"
      echo -e "8.FStrim Tweaks          : [${FSTRIM}]"
      echo -e "9.Donate"
      echo -e "10.Exit\n"
      sleep 0.3
      echo -n " -> Select the number : "
  
  read selected_prompt
	clear
	
  case $selected_prompt in
    1) menu_properties;;
	2) cmd_Power;;
	3) thermal_Service;;
	4) composition_Type;;
    5) renderer_Type;;
    6) memory_Factor;;
    7) just_in_time;;
    8) fstrim;;
    9) donate;;
	10) clear && break ;;
		esac
        repeat
		clear && break
	done
}

case $1 in
"-s");;
*) project_Atomic;;
esac

# // Sync to data in the rare case a device crashes
sync

                      # bye bye......
                # thanks all contributors...
