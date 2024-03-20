FROM pytorch/pytorch:2.2.0-cuda11.8-cudnn8-runtime

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git python3-tk libgl1 libglib2.0 && apt-get clean

RUN pip install tensorflow[and-cuda]==2.10.1 --extra-index-url https://pypi.nvidia.com

ENV ROOT=/lora-scripts
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone --recurse-submodules https://github.com/Akegarasu/lora-scripts ${ROOT} && \
  cd ${ROOT} && \
  git checkout main

WORKDIR ${ROOT}/sd-scripts
RUN pip install -r requirements.txt

WORKDIR ${ROOT}
RUN pip install xformers --index-url https://download.pytorch.org/whl/cu118
RUN pip install -r requirements.txt

COPY . /docker/
ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python gui.py --listen --port 7860 ${CLI_ARGS}