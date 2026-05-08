# Release Process Documentation

This repository uses the following steps to create a new version that will be published to npm and automatically installed by users who run `npm i -g scriptvault`.

## 1. Bump the version

Update the `version` field in `package.json` to the next semantic version. A *patch* change (`0.1.0 → 0.1.1`) is typical for a new feature or bug fix.

```bash
# In the repository root
sed -i "s/\"version\": \"\([0-9]\.[0-9]\.[0-9]\)\",/\"version\": \"\1.1\",/" package.json
```  

Commit the change.

## 2. Commit & tag

```bash
git add package.json CHANGELOG.md
git commit -m "chore: bump to 0.1.1"

# Tag the release – include the v prefix’ if you prefer
git tag -a v0.1.1 -m "Release v0.1.1"

git push && git push --tags
```

## 3. Publish to npm

Run the publish command. If you have two‑factor authentication (2FA) enforced on your npm account you’ll need a token that bypasses 2FA or you’ll be prompted for a verification code.

```bash
npm publish --access public
```

If the publish succeeds, npm will live‑update any global installation of the package.

## 4. (Optional) GitHub Actions automation

Below is a minimal GitHub Actions workflow that automatically publishes the package when a tag that starts with `v` is pushed. It requires an `NPM_TOKEN` secret with *publish* scope.

```yaml
# .github/workflows/npm-publish.yml
name: Publish to npm

on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          registry-url: https://registry.npmjs.org
      - run: npm ci --production
      - run: npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### Setting up the secret

1. In your GitHub repository, go to **Settings → Secrets → Actions**.
2. Click **New repository secret**.
3. Name: `NPM_TOKEN`
4. Value: Copy the *publish* token you generated on <https://www.npmjs.com/settings/tokens>. **Make sure the token includes `publish` scope and is set to bypass 2FA.**

Once the secret is set, the workflow will run automatically whenever you push a new `v*` tag. No manual intervention is required.

## 5. Verify the update

After the workflow finishes, run

```bash
npm show scriptvault version
```

to confirm that the latest version is visible in the registry. Then users can refresh their global installation with `npm update -g scriptvault`.

---

*Tip:* If you want to keep your documentation close to the code, you can put this file in a `docs/` directory – it won’t be published to npm but will be part of the repository.
