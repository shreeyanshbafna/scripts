#!/bin/bash


echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell

source /root/.bashrc # setup autocomplete in bash into the current shell, bash-completion package should be installed first.

