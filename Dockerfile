
FROM ubuntu:focal
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update && apt-get upgrade -y

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata 

RUN apt-get install -y build-essential    
RUN apt-get install -y cmake
RUN apt-get install -y python3-pip
RUN apt-get install -y git

# NEOVIM DEP
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y zip \
    && apt-get install -y python3-venv \
    && apt-get install -y ripgrep \
    && apt-get install -y wget \     
    && apt-get install -y npm

RUN wget --progress=dot:giga https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz \
    && tar xzvf nvim-linux64.tar.gz -C /opt \
    && rm nvim-linux64.tar.gz \
    && ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim 

WORKDIR /home/${USERNAME}
RUN wget --progress=dot:giga https://github.com/cdot15/DEV_TOOLS/raw/refs/heads/ubuntu20/nvim.tar.gz \
    && mkdir .config \
    && tar xzvf nvim.tar.gz -C /home/${USERNAME}/.config \
    && rm nvim.tar.gz \
    && apt-get install -y tmux 

RUN echo 'alias tmux="TERM=screen-256color-bce tmux"' >> .bashrc

ENV SHELL /bin/bash

USER $USERNAME
CMD ["/bin/bash"]
