# Git Clang-Format Check

Pre-Commit Hook for Git to Check the Correct Formatting of All Staged C and C++ Source Files

<p align="center">
    <img src="https://img.shields.io/github/languages/top/lyrahgames/git-clang-format-check.svg?style=for-the-badge">
    <img src="https://img.shields.io/github/languages/code-size/lyrahgames/git-clang-format-check.svg?style=for-the-badge">
    <img src="https://img.shields.io/github/repo-size/lyrahgames/git-clang-format-check.svg?style=for-the-badge">
    <a href="COPYING.md">
        <img src="https://img.shields.io/github/license/lyrahgames/git-clang-format-check.svg?style=for-the-badge&color=blue">
    </a>
</p>

## Author
- Markus Pawellek "lyrahgames" (lyrahgames@mailbox.org)

## Use in `.githooks` Directory by Using a Submodule

Inside the directory of your project, run the following commands.

    mkdir .githooks
    cd .githooks
    git submodule add -f https://github.com/lyrahgames/git-clang-format-check.git clang-format-check
    ln -s clang-format-check/hook.sh pre-commit

Instead of a symbolic link, you can create your own `pre-commit` script and add this script to other pre-commit scripts by checking its exit status.

Make sure to enable `.githooks` directory as hooks directory for your current project.

    git config --local core.hooksPath .githooks

