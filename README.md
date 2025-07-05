## Gretch - System Information Gathering Script

**Shell script written in bash for Linux Mint.**  
**Display system information in your terminal.**    

Information displayed  includes:

OS/Version  
DE  
Kernel  
Uptime  
Shell    
Theme  
Icons  
Resolution  
Packages  
CPU  
GPU    

<br />

**Instructions:**

1. Clone the repository (it will go to your home directory).
2. Open your terminal and cd (change directory) into the newly created 'gretch' folder. (cd gretch)
3. Once there, you can run script using: `./gretch.sh`  
4. Note: you may need to change permission by typing: `chmod +x gretch.sh`    

<br />

**Or, Download the ZIP**    
1. This will go to your Downloads folder (as gretch-main).  
2. Extract files if necessary.  
3. Open terminal and cd to Downloads (cd Downloads), then to gretch-main (cd gretch-main).  
4. From there, type: `chmod +x gretch.sh`     
5. Run script using `./gretch.sh`  

Of course, you can save the files to a location of your choice (e.g. bin/bash)

<br />
 
If any problems with display:  

tr (translate) was used for deleting characters in output,  
mostly parenthesis ( ), brackets [ ], and single quotes ' '.  

The cut command was also used to delete unnecessary output.  

In printf, (e.g. %-5s) is used for spacing between printf and output.   
Adjust accordingly if need be.  

<br />  

**Optional***  
This can be made to run everytime you open your terminal  
by placing the path (or alias) to script at the end of the .bashrc file.  

Example alias (place in .bashrc):  

`alias gret="~/bin/bash/gretch.sh"`  

Then just place alias at bottom of .bashrc  

`gret`  

To undo: comment out alias  
`#gret`  

<br />  

