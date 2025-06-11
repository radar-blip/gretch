# gretch

Small program made with bash for linux mint.  
Collects and displays information of Linux Mint systems.


Information displayed includes:

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

 
If any problems with display:  

tr (translate) was used for deleting characters in output,  
mostly parenthesis ( ), brackets [ ], and single quotes ' '.  

The cut command was also used to delete certain characters from output.  

In printf, %-5s is used for spacing between printf and output.   
Adjust accordingly if need be.  


Optional*  
This can run everytime you open your terminal by placing the path (or alias) to program at the end of the .bashrc file. 
Careful not to mess anything else up in .bashrc.

enjoy
