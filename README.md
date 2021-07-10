# Simple CodeQL Local Scanner

quick and dirty way to scan local projects

in order to scan a local project edit the docker-compose.yml file.

Change this volume:

```bash
  - /f/node_sandbox/NodeTestBench:/opt/src
```

to the volume of the project you want to use.  Make sure its mapped to /opt/src

---

edit the entrypoint.sh file if you want to change the language or suite that gets run

---

## to run this project and dispose of container when scan is complete

```bash
docker compose up && docker compose down
```

---

## to view the results

* you will need a sarif viewer: <https://marketplace.visualstudio.com/items?itemName=MS-SarifVSCode.sarif-viewer>
* result sarif file can be found at `./codeql-results/issues.sarif` after the scan completes

---

Note: Make sure to review the CodeQL license and ensure that you are within its restrictions.
<https://securitylab.github.com/tools/codeql/license/>
