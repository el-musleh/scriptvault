# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.1.x   | ✅ Yes    |

## Reporting a Vulnerability

**Please do not create a public GitHub issue to report security vulnerabilities.**

Instead, please email `mohammadmusleh3@gmail.com` with:

1. **Title**: Brief description of the vulnerability
2. **Description**: Detailed explanation of the security issue
3. **Steps to Reproduce**: How to trigger the vulnerability
4. **Potential Impact**: Who could be affected and how
5. **Suggested Fix**: Any suggestions for remediation (optional)

### Response Timeline

- **Acknowledgment**: Within 24 hours
- **Initial Assessment**: Within 7 days
- **Fix Released**: Aim for as soon as possible after assessment

## Security Best Practices for Users

When using `scriptvault`:

- **Only run trusted scripts** — `scriptvault` executes whatever script you select
- **Verify scripts before running** — use `scriptvault edit <name>` to review
- **Keep scripts updated** — check for changes from trusted sources
- **Use sensible permissions** — scripts should have appropriate file permissions
- **Avoid scripts from untrusted sources** — script injection is always a risk

## Security Considerations for Contributors

When contributing scripts or code:

- **Input validation**: If your code takes user input, validate it thoroughly
- **No shell injection**: Never pass unquoted variables to shell commands
- **Prefer builtins**: Use bash builtins instead of external commands when safe
- **Error handling**: Use `set -euo pipefail` and proper error checking
- **No credentials**: Never hardcode credentials or secrets in scripts

Example of safe vs unsafe code:

```bash
# ❌ UNSAFE: Variable expansion in command
my_script="${user_input}.sh"
bash "$my_script"  # Dangerous if user_input is not trusted

# ✅ SAFE: Validate before using
if [[ "$user_input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  my_script="${user_input}.sh"
  bash "$my_script"
else
  echo "Invalid script name" >&2
  exit 1
fi
```

## Known Limitations

- `scriptvault` relies on `gnome-terminal` for interactive launching — it will not work over SSH or in headless environments
- Scripts run with the permissions of the user executing `scriptvault`
- The vault directory is not encrypted — treat it as you would any local directory

## Contact

For security inquiries, email: `mohammadmusleh3@gmail.com`
