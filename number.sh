#!/bin/bash

# eval $cd $dir and make if DNE
cd='eval "if [[ ! -d $home/$dir ]]; then mkdir -p $home/$dir; fi; cd $home/$dir"'
