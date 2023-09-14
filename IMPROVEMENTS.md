# Improvements

- Improve documentation, adding test procedures.
- Add most test cases.
- Add the rest of the entries types supported.
- Automate the development workflow, linting the code before, and generating the documentation.
- Improve the DNS configuration for testing, applying security to update the dynamic DNS entries. This implies managing secrets in the Terraform code, perhaps using a vault solution. Evaluate the security of the DNS Server.
- Automate the testing workflow.
- The IP of the DNS Server should be a variable with default.
