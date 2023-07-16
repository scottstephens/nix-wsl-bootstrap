# nix-wsl-bootstrap

## Intro

This project aims to make it easy to get a Nix development environment up and running on Windows 11. You run a powershell script, answer five questions (that come with sane defaults if you're not picky) and in a few minutes you'll have a WSL setup ready to clone repos and do Nix builds.

It does so by
1. Installing Alpine linux into the Windows Subsystem for Linux 2 (hereafter, WSL)
2. Minimally configuring Alpine as necessary for installing Nix and conveniently using it.
3. Installing Nix within the Alpine WSL distribution.
4. Configure the Nix installation and user profile in a somewhat opinionated but fairly lightweight manner:
   1. Enable the `nix-command` and `flakes` experimental features.
   2. Install ssh, git, and vim into the user profile.
   3. Within the Alpine WSL distribution ~/.ssh folder, create symlinks to the user's Windows SSH keys.

# Use

1. Enable virtualization and WSL2.

2. Have git, ssh, and powershell installed in Windows 11.

3. Clone this repo: `git clone git@github.com:scottstephens/nix-wsl-bootstrap`

4. Run `install.ps1`. It will ask you for
   1. The linux username you'd like to use within WSL.
   2. Your full name.
   3. What you'd like to name your WSL distribution.
   4. The folder in which you'd like to place your WSL distro.
   5. Whether you'd like a multi-user or single-user install.
   Sane defaults are provided for all of these, if you're not picky you will only need to press enter 5 times.

5. After the installation is finished, enter WSL in the usual manner. If it's your only WSL distribution, all you need is `wsl`. If you have another installed, you'll need `wsl -d Alpine`. If you have another installed and you didn't accept the default distro name, you need `wsl -d WhateverYouNamedYourDistro`. To get root access use `wsl --user root`.

6. Once in the WSL environment, you're ready to git clone any repos you want to work with, and use nix commands to build them.

## Rationale

WSL 2 is a goofy environment. At the core it is a virtualized Linux kernel, but it uses a custom init system, which makes it an awkward fit with distributions that rely heavily on systemd. This includes NixOS, Ubuntu, Debian, and Fedora, among many others. So if WSL is handling the kernel and init system, what else is left of these full featured distributions? Not much I care about, honestly. I'm not going to be running persistent services there. WSL isn't really designed to be used by different Windows users, so the user management stuff isn't useful. My selection of package versions and service orchestration is going to come from the Nix config associated with my development projects, not from the OS curation. So all I really want is nix, git, and ssh, and the config I need to use them. And that's exactly what this script gives you.

## Specific Design Choices

### Not using the NixOS WSL Distro

I tried it. It kept breaking when upgraded. Bootstrapping the config to the point where you can clone a git repo and run a nix build was also more challenging.

### Alpine

Basically because it's the most minimal commonly used WSL distro. I probably would have preferred a minimal glibc based distro, but there isn't one that's particularly popular in combination with WSL.

### Enabling nix-command and flakes

I like them, as do many others. If you don't, they're easy to ignore.

### Installing git and ssh

If you know somebody who doesn't have git and ssh in their login profile, I'd like to meet them.

### Installing vim

This is a little dicier. The real reason of course is that I use vim, but I do believe it's substantially more popular than emacs or nano. An option for those wouldn't be a terrible idea.

### Symlinking to Windows SSH Keys

Needed to make git clone of a private repo work out of the box, which was a primary design goal.
