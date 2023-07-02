# Hello-Ooba - Oobabooga "Hello World" API example for node.js with Express

![Screenshot](https://github.com/bashalarmist/hello-ooba/blob/master/readme/hello-ooba.png)


## Introduction
This is intended for users that want to develop with the Oobabooga OpenAI API locally, for example, to develop a bot that can connect to another service. I have provided this code as a starting point.

## Prerequisites
- Docker
- Docker Nvidia Container toolkit

## Hardware requirements
- 3080ti or better NVIDA GPU with 12GB memory or more

I have an Nvida graphics card, so this is created to work on that graphics card. You can get this to run with just your CPU, and probably an AMD graphics card, but you'll need to experiment with the settings. If you try this and you are successful, provide the configs you used and I will add them to the documentation.

## API Info
We are using the OpenAI implementation of the API endpoint.

Here is the OpenAI API documentation. It will contain helpful information.
[OpenAI API documentation](https://platform.openai.com/docs/guides/gpt)

## Usage
1. Copy the .env.example to .env `cp .env.example .env`
2. Set a compatible TORCH_CUDA_ARCH_LIST. See [CUDA GPUs](https://developer.nvidia.com/cuda-gpus)
3. Run setup.sh
4. From the repository root directory, run `docker compose up --build` (this will take sometime the first run)
5. You should be up and running. Test with `curl -X POST -H "Content-Type: application/json" -d '{"message":"Hello Ooba bot!"}' http://localhost:3001/prompt`

## Troubleshooting
TBD...


## Resources
- [Oobabooga Text-Generation-WebUI](https://github.com/oobabooga/text-generation-webui) - "A gradio web UI for running Large Language Models"
- [Hugging Face](https://huggingface.co) - The main place to download more LLMs
- [LocalLLaMA Subreddit](https://www.reddit.com/r/LocalLLaMA/) - A subreddit for LLM related discussion

## Contribute
Code contributions are welcome, as well as bitcoin donations:
bc1qnpvc8yp7tprewaam4v64ga8v0rhnyt67532tk5

![Bitcoin](https://i.imgur.com/Ixe1at6.jpg)