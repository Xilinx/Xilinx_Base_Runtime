#!/bin/bash

# $WORKSPACE: The absolute path of the directory assigned to the build as a workspace. Example: /proj/picasso/sdausr/jenkins/xsjrdevl116/workspace/software_shell_deployment
SSH_COMMAND="cd $WORKSPACE; ./build_all.sh"

# Run build script by ssh xbxcloud4
ssh -t xbxcloud4 $SSH_COMMAND
