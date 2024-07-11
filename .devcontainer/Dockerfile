FROM docker.io/zmkfirmware/zmk-dev-arm:3.5

COPY .bashrc tmp
RUN mv /tmp/.bashrc ~/.bashrc
RUN apt-get update && apt-get install -y build-essential git python3.12-venv
ENV ZMK_PATH /workspaces/zmk
RUN git clone https://github.com/zmkfirmware/zmk.git ${ZMK_PATH}
RUN cd ${ZMK_PATH} \
  && west init -l app/ \
  && west update \
  && west zephyr-export
RUN cd ${ZMK_PATH} \
  && python3 -m venv .venv \
  && . .venv/bin/activate \
  && pip3 install -r zephyr/scripts/requirements.txt

WORKDIR /workspaces/zmk-config
