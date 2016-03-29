#!/bin/bash

mkdir Distributed_files
cd Distributed_files
mkdir Dir1 Dir2 Dir3 Dir4
cd ..
i=0
for x in $1/*;
do
         i=`expr $i + 1`;
        if (( $i == 1 )); 
        then
        cp -r $x Distributed_files/Dir1/       
        fi
        if (( $i == 2 )); 
        then
        cp -r $x Distributed_files/Dir1/
        fi
        if (( $i == 3 )); 
        then
        cp -r $x Distributed_files/Dir2/
        fi
        if (( $i == 4 )); 
        then
        cp -r $x Distributed_files/Dir2/       
        fi
        if (( $i == 5 )); 
        then
        cp -r $x Distributed_files/Dir3/
        fi
        if (( $i == 6 )); 
        then
        cp -r $x Distributed_files/Dir3/
        fi
        if (( $i == 7 )); 
        then
        cp -r $x Distributed_files/Dir4/        
        fi
        if (( $i == 8 )); 
        then
        cp -r $x Distributed_files/Dir4/  
        i=0;
        fi
done
