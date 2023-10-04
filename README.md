## Fork-Purpose
The main purpose of this fork is to take the work done by [AbdBarho](https://github.com/AbdBarho) and fix some issues with it.
In general he did a really great job providing a platform to run Stable Diffusion on Docker.
I think that there are some flaws in his work tho, which I want to try and resolve:
- The docker-compose.yaml-file, while being elegant, is way to hard to edit for custom purposes.
- All containers are set up in a way, that they run as root which then leads to permission-problems on the host-machine.
- Setting up an environment that serves "everybody" is hard. Especially new people might struggle with leveraging the potential that some of the UIs offer.
- The project itself is not really beginner-friendly. Be it for beginners to Stable Diffusion or beginners in docker.

## How to use
### Setup
1. Set up docker (see https://docs.docker.com/engine/install/) -> This repo is tested on Ubuntu 22.04 LTS
2. (Optional) Modify the .env-file to your needs and likings. Please pay attention to the comments in there!
3. Run install.sh, answer its questions and wait for it to finish
### Usage
1. run `docker compose --profile [ui] up --build` -> where [ui] is one of invoke, auto, auto-cpu, comfy, or comfy-cpu.

## State of the Fork
### What works
- Download-Container
- A1111 is loadable and does it's job -> still WIP

### What does not
- ComfyUI (will be done next)
- InvokeAI

### What is currently in development
- I'm still working on A1111. It's done mostly, but the docker-stuff has to be improved.


## Changes to the original Repo and improvements
- General:
  - The docker-compose.yaml file is less elegant, but way better manageable.
  - All direct-bind-mounts have been removed for volume-mounts.
    - That process required some additional downloads in the download-container.
  - All containers are set to run as user 1000:1000 to accommodate the change from direct bind-mounts to volumes.
- A1111-SD-Webui:
  - The config-builder has been replaced with a working default-config.
  - Clearing up all temp-images on container-start
  - A1111 removed some vital settings from the main-ui to the Settings-Tab making them invisible. The following settings have been returned to the main-ui:
    - Restore Faces (txt2img/img2img)
    - Random-Source for seed (txt2img/img2img) -> set to CPU to make seeds more hardware-stable (see https://github.com/comfyanonymous/ComfyUI/discussions/118)
    - CLIP set last layer aka "CLIP-SKIP" (txt2img/img2img)
  - The initial setup comes with some widely-used extensions preinstalled
    - Regional Prompter (see https://github.com/hako-mikan/sd-webui-regional-prompter)
    - TiledVAE (see https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111)
    - ControlNet (see https://github.com/Mikubill/sd-webui-controlnet)

## Added Problems
Rarely any changes come without some problems that have to be solved in the future. Here they are:
 - System Requirements
   - You have to use Linux (especially one with systemd - like Debian or Ubuntu). Mac and Windows are not supported (I don't know if WSL will work - use at your own risk!)
     - This is due to limitations set by the local-persistent plugin for docker (see https://github.com/MatchbookLab/local-persist)
     - If you can figure out a way to run this natively on CentOS or how to set it up properly on arch - feel free to contribute!
   - For now you are limited to NVIDIA-Graphic-cards if you want to use anything else than the CPU-Versions.
     - I will look into some changed suggested to make AMD-Cards useable, but having none myself, I can't promise anything.
     - The good news tho - All settings made are tested on a GTX 1070, which is not really a strong card, so there is a good chance that your old hardware actually supports this repo.
 - The install-process is a bit more complicated than in the original. It's a bit more than just running two commands. I did my best tho.

## Credits
Most credits go to [AbdBarho](https://github.com/AbdBarho) for doing the pioneer work. I just added to that. :)

## Licence
I left all original licences in their respected place.
For now this repo comes "as is", with no warranties and I take no responsibility for what you do with it.

# Original Content
For the original documentation and everything see https://github.com/AbdBarho/stable-diffusion-webui-docker
