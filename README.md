## Fork-Purpose
The main purpose of this fork is to take the work done by [AbdBarho](https://github.com/AbdBarho) and fix some issues with it.
In general he did a really great job providing a platform to run Stable Diffusion on Docker.
For me personally there are some flaws in his work tho, which I want to try and resolve:
- The docker-compose.yaml-file, while being elegant, is way too hard to edit for custom purposes.
- All containers are set up in a way, that they run as root which then leads to permission-problems on the host-machine.
- Setting up an environment that serves "everybody" is hard. This repo aims to get a good base for people that use Stable-diffusion on a regular basis and complete beginners.
- The original project itself is not really beginner-friendly. Be it for beginners to Stable Diffusion or beginners in docker.

## How to use
### Setup
1. Set up docker (see https://docs.docker.com/engine/install/) -> This repo is tested on Ubuntu 22.04 LTS
2. Run `./install.sh`, answer its questions and wait for it to finish

**WARNING:** Different to other web-projects you might know - please do NOT just copy the .env.default-file to .env and start modifying!
   The install-script does that for you and adds some modifications on the first run! You don't want to do them by hand!
### Usage
#### You have two ways to start your containers:
1. run `./run.sh`, select your containers, press Enter and Go.
2. run `docker compose --profile [ui] up --build` -> where [ui] is one of invoke, auto, auto-cpu, comfy, or comfy-cpu if you want to start your containers manually.

### Notes regarding the softwares:
##### A1111-WebUI:
- If you use the ControlNet-Extension, it will download the respective used Annotators.
So the first time you use a "Preprocessor" might take a bit. The ControlNet-Models themselves are being downloaded - in the SD- (controlnet_vp_...) and XL-variants.

## State of the Fork
### What works
- Installation and booting up A1111-WebUi
- A1111 should be working normally

### What does not
- ComfyUI (will be done next)
- InvokeAI

### What is currently in development
- Right now I'm looking into brining up ComfyUI

### Environment
- This repo is tested on my old laptop with the following specs:
  - Processor: Intel Core™ i7-7700HQ
  - Graphics: GeForce GTX 1070 Mobile
  - RAM: 64 GB
  - OS: Ubuntu 22.04.3 LTS


## Changes to the original Repo and improvements
- General:
  - The docker-compose.yaml file is less elegant, but implemented in a way that it can leverage the .env-file.
  - All direct-bind-mounts have been reworked to be completely customizable.
    - That process required some additional downloads in the download-container.
  - All containers are set to run as user 1000:1000 to accommodate the change in the bind-mounts.
- A1111-SD-Webui:
  - The config-builder has been replaced with a working default-config.
  - All temp-images will be removed on the start of the container. This prevents a stacking-affect over time. Just restart the container once in a while.
  - A1111 removed some vital settings from the main-ui to the Settings-Tab making them invisible. The following settings have been returned to the main-ui:
    - Restore Faces (txt2img/img2img)
    - Random-Source for seed (txt2img/img2img) -> set to CPU to make seeds better shareable (see https://github.com/comfyanonymous/ComfyUI/discussions/118)
    - CLIP set last layer aka "CLIP-SKIP" (txt2img/img2img)
  - The initial setup comes with some widely-used extensions preinstalled (can be deactivated in the .env-file) those extensions are:
    - Regional Prompter (see https://github.com/hako-mikan/sd-webui-regional-prompter)
    - TiledVAE (see https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111)
    - ControlNet (see https://github.com/Mikubill/sd-webui-controlnet)
  - The Download-Container installs most external requirements

## Added Problems
Rarely any changes come without some problems that have to be solved in the future. Here they are:
 - System Requirements
   - For now you are limited to NVIDIA-Graphic-cards if you want to use anything else than the CPU-Versions.
     - I will look into some changes suggested to make AMD-Cards useable, but having none myself, I can't promise anything.
     - The good news tho - All settings made are tested on a GTX 1070, which is not really a strong card, so there is a good chance that your old hardware actually supports this repo.
   - The OS might be limited to Linux for now.
     - There are maaaaany links in the docker-compose.yaml-file that are all with Linux-Path-separators. I am not sure if or how well they translate to Windows...
 - The install-process is a bit more complicated when it runs into errors. You have to look out a bit, but in general everything should be very clear.
 - Possible Duplicates in FaceRestore- and ControlNet-Files
   - A1111 and ComfyUI are sometimes not compatible in their folder-structures. Therefore, some duplicate files are possible.
     - This should not be considered "bad" but more "inconvenient".

## Credits
Most credits go to [AbdBarho](https://github.com/AbdBarho) for doing the pioneer work. I just added to that. :)

## Licence
I left all original licences in their respected place.
This repo comes "as is", with no warranties and I take no responsibility for what you do with it.
You agree to use this repo in accordance with your local law.

# Original Content
For the original documentation and everything see https://github.com/AbdBarho/stable-diffusion-webui-docker
