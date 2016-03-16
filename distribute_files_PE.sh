#!/bin/bash

# mkdir distributed_files
# cd distributed_files
# mv ../$1 ./
mkdir Dir1 Dir2 Dir3 Dir4
i=0
for x in $1/*;
do
         i=`expr $i + 1`;
        if (( $i == 1 )); 
        then
        mv $x Dir1/
        fi
        if (( $i == 2 )); 
        then
        mv $x Dir1/
        fi
        if (( $i == 3 )); 
        then
        mv $x Dir2/
        fi
        if (( $i == 4 )); 
        then
        mv $x Dir2/       
        fi
        if (( $i == 5 )); 
        then
        mv $x Dir3/
        fi
        if (( $i == 6 )); 
        then
        mv $x Dir3/
        fi
        if (( $i == 7 )); 
        then
        mv $x Dir4/        
        fi
        if (( $i == 8 )); 
        then
        mv $x Dir4/  
        i=0;
        fi
done
