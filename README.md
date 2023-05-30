# Introduction

This is the code for the [The Total Noob's Guide to Harnessing the GPU for LLaMA Inference](https://medium.com/@_init_/the-total-noobs-guide-to-harnessing-the-gpu-for-llama-inference-2e3c4fdfbc84) blog post.

# Prerequisites
1. Docker
2. VS Code

# Usage

1. Open this project in the provided [devcontainer](./.devcontainer/devcontainer.json)

2. Run:
    ```bash
    # compile llamacpp and install its dependencies
    make clone-llamacpp-repo
    make compile-llamacpp
    make install-llamacpp-deps

    # get a model and convert it to something llamacpp can use
    make download-model
    make convert-model-to-f16
    make quantize-model

    # view inference timings
    make eval
    ```

