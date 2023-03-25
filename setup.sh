#/usr/bin/sh

# Copyright (c) 2023 hogedamari
# Released under the MIT license
# License notice:
# https://github.com/foo2810/quick-vim-configurator/blob/main/LICENSE


if [ -z ${IGN_CAUTION} ]; then
    IGN_CAUTION=0
fi

set -eu
STASH_DIR= STASH_VIMRC=
STASH_VIM_DIR=
STASH_DENO_DIR=

VIMRC="${HOME}/.vimrc"
VIM_DIR="${HOME}/.vim"
DENO_DIR="${HOME}/.deno"

SUCCESS=0


check_before_setup() {
    flg=0
    if [ -f ${VIMRC} ]; then
        echo "${VIMRC} detected"
        flg=1
    fi

    if [ -d ${VIM_DIR} ]; then
        echo "${VIM_DIR} detected"
        flg=1
    fi

    if [ -d ${DENO_DIR} ]; then
        echo "${DENO_DIR} detected"
        flg=1
    fi

    if [ -t 0 ]; then
        # Standard input is used
        if [ ${flg} -eq 1 ]; then
            yn=
            while true; do
                echo "These files and directories may be broken on error."
                read -p "Are you sure to execute setup script?: " yn
                case "${yn}" in
                    [yY]|"yes"|"YES"|"Yes")
                        return 0
                        break
                        ;;
                    [nN]|"no"|"NO"|"No")
                        return 1
                        break
                        ;;
                    *)
                        echo "Miss type? Please again."
                esac
            done

        fi
    else
        if [ "${IGN_CAUTION}" -eq 1 ] || [ ${flg} -eq 0 ]; then
            return 0
        else
            # Input from pipe
            printf "These files and directories may be broken on error. \nIf no problem, please execute following command.\n\n"
            echo "curl -fsSL https://raw.githubusercontent.com/foo2810/quick-vim-configurator/main/setup.sh | IGN_CAUTION=1 sh"
            return 1
        fi

    fi
    
    return 0
}

# FIXME: .vimrc, .vim, .deno are hard corded
stash() {
    STASH_DIR=$(mktemp -d)

    if [ -d ${VIM_DIR} ]; then
        cp -r ${VIM_DIR} ${STASH_DIR}
        STASH_VIMRC=${STASH_DIR}/.vimrc
    fi

    if [ -f ${VIMRC} ]; then
        cp ${VIMRC} ${STASH_DIR}
        STASH_VIM_DIR=${STASH_DIR}/.vim
    fi

    if [ -f ${DENO_DIR} ]; then
        cp ${DENO_DIR} ${STASH_DIR}
        STASH_VIM_DIR=${STASH_DIR}/.deno
    fi
}

revert() {
    if [ ! -z ${STASH_VIMRC} ]; then
        cp -f ${STASH_VIMRC} ${VIMRC}
    fi

    if [ ! -z ${STASH_VIM_DIR} ]; then
        cp -rf ${STASH_VIM_DIR} ${VIM_DIR}
    fi

    if [ ! -z ${STASH_DENO_DIR} ]; then
        cp -rf ${STASH_DENO_DIR} ${DENO_DIR}
    fi
}

clean_stash() {
    if [ ! -z ${STASH_VIMRC} ]; then
        rm -rf ${STASH_VIMRC}
    fi
    if [ ! -z ${STASH_VIM_DIR} ]; then
        rm -rf ${STASH_VIM_DIR}
    fi
    if [ ! -z ${STASH_DENO_DIR} ]; then
        rm -rf ${STASH_DENO_DIR}
    fi
    if [ ! -z ${STASH_DIR} ]; then
        rmdir ${STASH_DIR}
    fi

    STASH_VIMRC=
    STASH_VIM_DIR=
    STASH_DENO_DIR=
    STASH_DIR=
}

clean_old_env() {
    if [ -d ${VIM_DIR} ]; then
        rm -rf ${VIM_DIR}
    fi

    if [ -f ${VIMRC} ]; then
        rm -f ${VIMRC}
    fi

    if [ -d ${DENO_DIR} ]; then
        rm -rf ${DENO_DIR}
    fi
}

gen_vim_base_env() {
    clean_old_env

    mkdir -p ${VIM_DIR}/autoload \
             ${VIM_DIR}/colors \
             ${VIM_DIR}/plugged
    touch .vimrc
}

clean_on_exit() {
    exit_status=0

    # If not sucess
    if [ "${SUCCESS}" -eq 0 ]; then
	echo "Reverting files"
        clean_old_env
        revert
        exit_status=1
    fi

    clean_stash

    exit $exit_status
}

trap "clean_on_exit" TERM QUIT EXIT INT KILL


run_setup() {
    stash
    gen_vim_base_env


    # ddc setup
    ## install deno
    curl -fsSL https://deno.land/x/install/install.sh | bash
    if [ ! $? ]; then
        echo -e "Error: failed to install deno" 1>&2
        clean_on_exit
    fi

    ## vim script to install plugins (temporary)
    #curl -fo "${VIM_DIR}/autoload/plug_install.vim" \
    curl -fo "${VIMRC}" \
        https://raw.githubusercontent.com/foo2810/quick-vim-configurator/main/plug_install.vim
    if [ ! $? ]; then
        echo "Error: failed to download .vimrc" 1>&2
        clean_on_exit
    fi

    # download vim-plug
    curl -fo "${VIM_DIR}/autoload/plug.vim" \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ ! $? ]; then
        echo -e "Error: failed to download vim-plug" 1>&2
        clean_on_exit
    fi

    ## exec PlugInstall
    ### last "-" must need (Why?)
    vim  +PlugInstall +qall -

    ## remove temporary vim script
    #rm -f "${VIM_DIR}/autoload/plug_install.vim"
    rm -f "${VIMRC}"


    # download colorscheme "hybrid.vim"
    curl -fo "${VIM_DIR}/colors/hybrid.vim" \
        https://raw.githubusercontent.com/w0ng/vim-hybrid/master/colors/hybrid.vim
    if [ ! $? ]; then
        echo -e "Error: failed to download \"hybrid.vim\"" 1>&2
        clean_on_exit
    fi


    # download .vimrc
    curl -fo "${VIMRC}" \
        https://raw.githubusercontent.com/foo2810/quick-vim-configurator/main/.vimrc
    if [ ! $? ]; then
        echo "Error: failed to download .vimrc" 1>&2
        clean_on_exit
    fi

    cat << 'EOF' >> $HOME/.bashrc

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
EOF

    SUCCESS=1

    clean_on_exit
}



# [Main Part]
if ! check_before_setup; then
    SUCCESS=1
else
    run_setup
fi

