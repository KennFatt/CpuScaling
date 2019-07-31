# CPU Scaling (intel_pstate)

Force your CPU to run at specific frequency without logout or rebooting the system. **Fast and accurate**!
 
**Disclaimer**: Not all CPU are supported, it's only works with Sandy Bridge or newer.  

## How to use
All you have to do is edit the available modes.
Here is some available modes:
* auto: This is technically working without any limitation (default).
* idle: Save the most power and cooling the system, this might slow down your activty or task.
* performance: Use maximum available frequency, choose this one for important purpose only! Nothing bad would happend tho.
* save: This is recommended for Browsing or Streaming online, have a limitation at some point.  

## Important  
___
**scaling_max_freq**  
For `idle` mode, you have to set `scaling_max_freq` as lowest as your CPU can handle, mine was 800MHz.
Add some buffer to make it works fine, for example 800 + 50 = 850Mhz => 850000.
___
**scaling_governor**  
Choose the right governor scaling method.
See available governors for your CPU:
```
cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors
```
The output would be like this (less or more):
```
performance powersave
```