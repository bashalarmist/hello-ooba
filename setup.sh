#!/bin/bash

BASE_DIR=$(pwd)
TMP_DIR="${BASE_DIR}/tmp"
OOBA_DATA_DIR="${BASE_DIR}/ooba_data"

create_directories() {
    echo "Creating tmp and ooba_data directories at ${BASE_DIR}." 
    
    # Check if tmp directory exists in the current directory
    if [ -d "${TMP_DIR}" ]; then
        # If it does, print an error message and exit
        echo "ERROR: Directory ${TMP_DIR} already exists. Please delete it before running this script."
        exit 1
    else
        # If it doesn't, create the tmp directory
        mkdir "${TMP_DIR}"
    fi

    # Check if ooba_data directory exists in the current directory
    if [ -d "${OOBA_DATA_DIR}" ]; then
        # If it does, print an error message and exit
        echo "ERROR: Directory ${OOBA_DATA_DIR} already exists. Please delete it before running this script..."
        exit 1
    else
        # If it doesn't, create the ooba_data directory
        mkdir "${OOBA_DATA_DIR}"
    fi
}

clone_git_repo() {
    echo "- Initializing empty oobabooga repo into the newly created tmp directory..." 
    # change into the new tmp directory
    cd "${TMP_DIR}"

    # partial clone oobabooga repo
    git clone -n --depth=1 --filter=tree:0 https://github.com/oobabooga/text-generation-webui.git

    wait 

    # change into the newly cloned directory
    cd "${TMP_DIR}/text-generation-webui"

    git checkout
}

move_files() {
    echo "- Partially cloning the oobabooga repo into the empty oobabooga repo directory..." 

    # set directories to sparse-checkout
    git sparse-checkout set models presets training characters extensions loras && \
    # Move the directories into ooba_data, if the sparse-checkout was successful
    mv loras "${OOBA_DATA_DIR}" && \
    mv models "${OOBA_DATA_DIR}" && \
    mv presets "${OOBA_DATA_DIR}" && \
    mv training "${OOBA_DATA_DIR}" && \
    mv characters "${OOBA_DATA_DIR}" && \
    mv extensions "${OOBA_DATA_DIR}"
}

delete_dirs() {
    echo "- Safely removing ${TMP_DIR} and subdirectories..."

    # Go back to the parent directory
    cd "${BASE_DIR}"

    # Check if the ./tmp/text-generation-webui/.git directory exists, then delete it
    if [ -d "${TMP_DIR}/text-generation-webui/.git" ]; then
        # If it does, delete it
        rm -rf "${TMP_DIR}/text-generation-webui/.git"
    else
        # If it doesn't, print an error message
        echo "ERROR: ${TMP_DIR}/text-generation-webui/.git does not exist."
        exit 1
    fi

    # Check if the ./tmp/text-generation-webui directory is empty
    if [ ! "$(ls -A ${TMP_DIR}/text-generation-webui)" ]; then
        # If it is, delete the ./tmp/text-generation-webui directory
        rm -r "${TMP_DIR}/text-generation-webui"
    else
        # If it's not, print an error message
        echo "ERROR: ${TMP_DIR}/text-generation-webui directory is not empty. Not deleting the directory."
        exit 1
    fi

    # Check if the tmp directory is empty
    if [ ! "$(ls -A ${TMP_DIR})" ]; then
        # If it is, delete the tmp directory
        rm -r "${TMP_DIR}"
    else
        # If it's not, print an error message
        echo "ERROR: ${TMP_DIR} directory is not empty. Not deleting the directory."
        exit 1
    fi
}

download_model() {
    # Ask the user if they want to download the model
    read -p "- Do you want to download the TheBloke_wizard-vicuna-13B-GPTQ model (~8GB) from hugging face? If you do not do this, you will need to do manually add a model. (Y/N)" answer

    # Convert the answer to lower case
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    if [ "$answer" = "y" ]; then
        # Create the directory where the model will be downloaded
        MODEL_DIR="${OOBA_DATA_DIR}/models/TheBloke_wizard-vicuna-13B-GPTQ"
        mkdir -p "${MODEL_DIR}"

        # Download the model files
        echo "Downloading model into ${MODEL_DIR}..."
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/Wizard-Vicuna-13B-Uncensored-GPTQ-4bit-128g.compat.no-act-order.safetensors
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/config.json
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/tokenizer.model
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/tokenizer.json
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/tokenizer_config.json
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/generation_config.json
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/quantize_config.json
        wget -P "${MODEL_DIR}" https://huggingface.co/TheBloke/Wizard-Vicuna-13B-Uncensored-GPTQ/resolve/main/special_tokens_map.json



    else
        echo "Skipping model download."
    fi
}

create_directories
clone_git_repo
move_files
delete_dirs
download_model

echo "Setup complete. Run start services with:"
echo "docker compose up --build"
