# Dotfiles

A collection of dotfiles for my development workflow.


## Notes

*   **Configuration Management:**  Provides a centralized location for managing configuration 
files.
*   **Symlink Creation:** Creates symlinks to the dotfiles in this repository, instead of putting these
files into filesystem, so there is no need to clone this to your `~` folder. 
*   **Backup Mechanism:** Backs up existing files with a `.bak` extension before creating 
symlinks, allowing for easy restoration if needed.
*   **Targeted Deployment:**  Allows you to deploy specific dotfiles or all dotfiles to your 
home directory.

## Installation
0. Explore possible configurations and run `deploy -h`.
1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/ostap4ello/dotfiles.git
    cd dotfiles
    ```

2.  **Run the Deployment Script:**

    *   **Deploy All Dotfiles:**
        ```bash
        ./deploy.sh -a
        ```

    *   **Deploy Specific Dotfiles:**
        ```bash
        ./deploy.sh -t .bashrc
        ```

## Usage

The `deploy.sh` script handles the deployment of the dotfiles.  It uses symlinks to create a 
consistent environment.

*   **Deploy All:**  The `-a` or `--all` option deploys all dotfiles to your home directory.
*   **Deploy Specific Targets:** The `-t` or `--target` option allows you to deploy only 
specific dotfiles.  For example, `deploy.sh -t .bashrc` will deploy the `.bashrc` file.
