# define SAGE env
# do this before activating conda
export SAGE_ROOT=$HOME/sage
source $HOME/sage/local/bin/sage-env
# unset some env that sage sets that it shouldn't
unset IPYTHONDIR
unset JUPYTER_CONFIG_DIR
unset JUPYER_SERVER_ROOT
unset JUPYTER_SERVER_URL
