FROM pytorch/pytorch:2.2.0-cuda11.8-cudnn8-runtime

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git libgl1 libglib2.0 && apt-get clean
RUN conda install nvidia/label/cuda-11.8.0::cuda-nvrtc -y
WORKDIR /opt/conda/lib
RUN ln -s libnvrtc.so.11.8.89 libnvrtc.so

ENV ROOT=/Fooocus
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/lllyasviel/Fooocus.git ${ROOT} && \
  cd ${ROOT} && \
  git checkout main

WORKDIR ${ROOT}
#RUN pip install xformers --index-url https://download.pytorch.org/whl/cu118
RUN pip install -r requirements_versions.txt

COPY entrypoint.sh /docker/
COPY config.txt /Fooocus/
ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python entry_with_update.py --listen --port 7860 ${CLI_ARGS}