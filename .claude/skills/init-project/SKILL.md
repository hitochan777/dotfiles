---
name: init-project
description: Initialize a new project with common setup files
argument-hint: "[language]"
allowed-tools: Bash(gi *), Bash(ls *)
---

Initialize a new project by generating a `.gitignore` file for the specified language/framework.

## Steps

1. Run `gi $ARGUMENTS > .gitignore` to generate the `.gitignore` file using gitignore.io
2. Confirm the file was created successfully
