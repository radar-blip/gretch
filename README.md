## gretch

Shell script made for Linux Mint.  
Can be run from your terminal to display your systems information.  

Displayed information includes:

OS  
Version  
DE  
Kernel  
Uptime  
Shell  
WM  
WM Theme  
Resolution  
Packages  
CPU  
GPU    

<br />
 
If any problems with display:  

tr (translate) was used for deleting characters in output,  
mostly parenthesis ( ), brackets [ ], and single quotes ' '.  

The cut command was also used to delete certain characters from output.  

In printf, %-5s is used for spacing between printf and output.   
Adjust accordingly if need be.  

<br />  

**Optional***  
This can run everytime you open your terminal by placing the path (or alias) to program at the end of the .bashrc file.  

<br />  

**Note:** Any info not wanted and/or needed to be displayed can be commented out in code.
