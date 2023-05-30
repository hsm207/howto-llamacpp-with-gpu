SHELL=/bin/bash

clone-llamacpp-repo:
	@if [ ! -d "llama.cpp" ]; then \
		git clone --branch master-7552ac5 https://github.com/ggerganov/llama.cpp.git; \
	fi
	
compile-llamacpp:
	@pushd llama.cpp && \
		make clean && \
		make LLAMA_CUBLAS=1

compile-llamacpp-no-gpu:
	@pushd llama.cpp && \
		make clean && \
		make

download-model:
	@if ! command -v git-lfs &> /dev/null; then \
        sudo apt-get install -y git-lfs; \
        git lfs install; \
    fi && \
    if [ ! -d "open_llama_7b_700bt_preview" ]; then \
        git clone https://huggingface.co/openlm-research/open_llama_7b_700bt_preview; \
    fi

install-llamacpp-deps:
	@pushd llama.cpp && \
		python -m pip install -r requirements.txt

convert-model-to-f16:
	@pushd llama.cpp && \
		mkdir -p models/7B && \
		python convert.py ../open_llama_7b_700bt_preview \
			--outfile models/7B/ggml-open-llama-7b-700bt-preview-f16.bin

quantize-model:
	@pushd llama.cpp && \
		./quantize models/7B/ggml-open-llama-7b-700bt-preview-f16.bin q8_0

eval:
	@pushd llama.cpp && \
		./main -m ./models/7B/ggml-model-q8_0.bin \
			-n 128 \
			--n-gpu-layers 32 
eval-no-gpu:
	@pushd llama.cpp && \
		./main -m ./models/7B/ggml-model-q8_0.bin -n 128

interactive:
	@pushd llama.cpp && \
		./main -m ./models/7B/ggml-model-q8_0.bin \
			-n 256 \
			--interactive-first \
			--repeat_penalty 1.0 \
			--color \
			-r "User:" \
			-f prompts/dan.txt

get-hardware-info:
	@if ! command -v lspci &> /dev/null; then \
        echo "Installing pciutils..."; \
        apt-get install -y pciutils; \
	fi
	@echo "Gathering hardware information..."
	@CPU_MODEL=$$(lscpu | grep 'Model name' | cut -d ':' -f 2 | sed 's/^ *//g'); \
	echo "CPU model: $$CPU_MODEL"
	@GPU_MODEL=$$(lspci | grep -i '3d' | cut -d ':' -f 3- | sed 's/^ *//g'); \
	echo "GPU model: $$GPU_MODEL"
	@CUDA_VERSION=$$(nvcc --version | grep 'release' | awk '{print $6}'); \
	echo "CUDA version: $$CUDA_VERSION"
	@CUDNN_MAJOR=$$(grep -m 1 CUDNN_MAJOR /usr/include/cudnn_version.h | awk '{print $$3}'); \
    CUDNN_MINOR=$$(grep -m 1 CUDNN_MINOR /usr/include/cudnn_version.h | awk '{print $$3}'); \
    CUDNN_PATCHLEVEL=$$(grep -m 1 CUDNN_PATCHLEVEL /usr/include/cudnn_version.h | awk '{print $$3}'); \
    echo "cuDNN version: $$CUDNN_MAJOR.$$CUDNN_MINOR.$$CUDNN_PATCHLEVEL"
