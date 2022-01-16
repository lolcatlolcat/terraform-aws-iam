 ## Contribution
  Branch off main, open a PR! All are welcome!

  When youre ready to create a new release, just do the following:
  1. `git describe --tags --abbrev=0`
  2. Increment your version +1
  3. `git tag v$VERSION && git push origin v$VERSION`

  This file `README.md` is maintained by [terraform-docs](https://terraform-docs.io/), changes to this file may be overwritten.

  Additionally, this module relies on the following tools to be installed prior to committing any changes:
  * [terraform](https://www.terraform.io/) for `terraform fmt`
  * [tfsec](https://github.com/aquasecurity/tfsec) for security validation
  * [terraform-docs](https://terraform-docs.io/) for document generation
  * [pre-commit](https://pre-commit.com/)
