ARG NV_RELEASE=25.11


FROM nvcr.io/nvidia/tensorrt:${NV_RELEASE}-py3 AS builder


FROM hieupth/mamba:24.04

RUN conda install -y \
      rattler-build \
      jinja2 \
      psutil \
      distro \
      requests \
    && conda clean -ay

# Copy tensorrt
COPY --from=builder /opt/tensorrt /opt/tensorrt

ENV LD_LIBRARY_PATH=/opt/tensorrt/lib:${LD_LIBRARY_PATH}
RUN echo "/opt/tensorrt/lib" > /etc/ld.so.conf.d/tensorrt.conf && \
    ldconfig

