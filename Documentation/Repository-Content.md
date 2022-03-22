<p align="center">
    <h1 align="center">
        What can be found in this repository?
    </h1>
</p>

- **Workspace initialization** when an issue is assigned and a specific label added to it:
  - create a new branch dedicated to the issue
  - create a new Power Platform Dev environment dedicated to the issue and add the developer as System Administrator
  - import the existing solution in the repository to the new Dev environment (*if it exists*)
  - add comments to the issue with workspace details (*branch an Dev environment*)
  - add a specific label to the issue to indicate a Power Platform Dev environment has been created for this issue
- **On-demand solution export and unpack** from a Power Platform Dev environment using the issue number and the name of the considered solution
- **Solution validation** on the "work in progress" version of a solution on the creation of a pull request targeting the main branch
- **Import solution to a Power Platform Validation environment** when a new commit is made on the main branch with changes in the **Solutions/** folder
- **Clean a development workspace** when the associated issue is closed or deleted
- **Create a GitHub release** and **deploy the managed solution in it to a Power Platform Production environment**

> *Note: Some of these features used a Just In Time (JIT) Power Platform Build environment to build a managed version of a solution based on an exported and unpacked unmanaged solution.*

<h3 align="center">
  <a href="../README.md#-documentation">🏡 README - Documentation</a>
</h3>