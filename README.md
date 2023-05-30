# Introduction

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

