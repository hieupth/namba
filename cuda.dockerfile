ARG NV_RELEASE=25.11


FROM nvcr.io/nvidia/tensorrt:${NV_RELEASE}-py3 AS builder


FROM hieupth/namba:${NV_RELEASE}
# Copy CUDA toolkit tree
COPY --from=builder /usr/local/cuda /usr/local/cuda
COPY --from=builder /usr/local/cuda-*/ /usr/local/cuda-*/
COPY --from=builder /etc/ld.so.conf.d/*cuda* /etc/ld.so.conf.d/
COPY --from=builder /etc/ld.so.conf.d/*nvidia* /etc/ld.so.conf.d/
COPY --from=builder /usr/lib/${MULTIARCH_LIBDIR}/ /usr/lib/${MULTIARCH_LIBDIR}/

# Importance envs.
ENV CUDA_HOME=/usr/local/cuda \
    PATH=/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

RUN ldconfig && \
    which nvcc && nvcc -V && \
    ls -la /opt/tensorrt | head && \
    ldconfig -p | egrep "cudnn|nccl|nvinfer|cudart" || true