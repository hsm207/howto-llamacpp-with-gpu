download-model:
	mkdir -p models
	curl -o models/ggml-vicuna-7b-1.1-q4_2.bin https://gpt4all.io/models/ggml-vicuna-7b-1.1-q4_2.bin

clone-llamacpp-repo:
	@if [ ! -d "llama.cpp" ]; then \
		git clone --branch master-7552ac5 https://github.com/ggerganov/llama.cpp.git; \
	fi