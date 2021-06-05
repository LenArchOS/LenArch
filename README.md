<p align="center">
<img src="img/logo-full.png" height="250" width="250" alt="Archcraft">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=flat-square">
  <img src="https://img.shields.io/github/license/lenarchos/lenarch?style=flat-square">
  <img src="https://img.shields.io/github/stars/lenarchos/lenarch?style=flat-square">
  <img src="https://img.shields.io/github/forks/lenarchos/lenarch?color=teal&style=flat-square">
  <img src="https://img.shields.io/github/issues/lenarchos/lenarch?color=violet&style=flat-square">
</p>

<h1 align="center">LenArch</h1>
<p align="center">
An Arch Linux distro built to my liking, based on <a href="https://github.com/archcraft-os/archcraft">ArchCraft</a>
</p>

**Building the ISO:**

**_Check list_**

- [ ] **archiso** version : `54-1`
- [ ] At least 10GB of free space
- [ ] Arch Linux 64-bit only
- [ ] Clear pacman cache; `sudo pacman -Scc`

* Open terminal and clone the **LenArch** repository.

```bash
git clone https://github.com/lenarchos/LenArch.git
```

- Change to the **LenArch** directory & run `setup.sh`.

```bash
cd LenArch
chmod +x setup.sh
./setup.sh
```

- Now, Change to the **iso** directory & run `build.sh` as **root**.

```bash
cd iso
sudo su
./build.sh -v
```

- If everything goes well, you'll have the ISO in **iso/out** directory. <br />

> If you want to Rebuild the ISO, remove **_work_** & **_out_** dirs inside `iso` directory first. then run `./build.sh -v` as **root**. You don't need to run `setup.sh` again, it's a one time process only.
