# Working Instructions — takebakker.dev Blog

Quick reference for day-to-day blog work. When in doubt, check here first.

---

## First-Time Infrastructure Deployment

Run once to provision Azure resources (Static Web App + Blob Storage).

```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars
# Verify values in terraform.tfvars
terraform init
terraform plan
terraform apply
```

After apply, do these two things:

**1. Add the GitHub Secret**

```bash
terraform output -raw static_web_app_api_key
```

Copy the value → GitHub repo → Settings → Secrets and variables → Actions → New secret:
- Name: `AZURE_STATIC_WEB_APPS_API_TOKEN`
- Value: the key you just copied

**2. Configure your custom domain DNS**

```bash
terraform output static_web_app_default_hostname
```

In your domain registrar, add:

| Record type      | Name  | Value                        |
|------------------|-------|------------------------------|
| CNAME (or ALIAS) | `@`   | `[output].azurestaticapps.net` |
| CNAME            | `www` | `[output].azurestaticapps.net` |

Then in the Azure Portal → Static Web Apps → Custom domains → add `takebakker.dev` and `www.takebakker.dev`. TLS is provisioned automatically.

Also configure the www → apex redirect in Azure Portal → Static Web Apps → Custom domains → set redirect.

---

## Creating a New Post

```bash
hugo new posts/my-post-slug.md
```

Opens `content/posts/my-post-slug.md` with pre-filled frontmatter. Change `draft: true` to `draft: false` when ready to publish.

**Frontmatter fields:**
- `title` — post title (update from the auto-generated one)
- `date` — set to today's date
- `draft` — keep `true` while working, set `false` to publish
- `tags` — list of tags, e.g. `[azure, networking]`
- `description` — one sentence shown in post cards and Open Graph

---

## Creating a New Gallery Album

```bash
hugo new gallery/album-slug/index.md
```

Opens `content/gallery/album-slug/index.md`. Fill in the `images` list with your Blob Storage CDN URLs (see Photo Upload below).

---

## Uploading Photos to Azure Blob Storage

1. Upload image(s) to the storage account:

```bash
az storage blob upload \
  --account-name stblogtakebakker \
  --container-name blog-media \
  --name gallery/[album-slug]/[filename].jpg \
  --file "[local path to file]" \
  --content-type image/jpeg
```

2. The public URL will be:
   `https://stblogtakebakker.blob.core.windows.net/blog-media/gallery/[album-slug]/[filename].jpg`

3. Add that URL to the `images` list in your album Markdown file.

**Bulk upload tip:** Use Azure Storage Explorer (GUI drag-and-drop) for uploading multiple photos at once.

---

## Working with Claude on Posts

### Starting a session

Open a Claude Code session in this repo directory. Claude reads `CLAUDE.md` automatically and writes in your voice.

### Collaboration modes

**You draft, Claude refines:**
- Write rough notes or a partial draft in `content/drafts/`
- Say: "Refine this draft into a full post: [reference the file]"

**Claude drafts from your brief:**
- Say: "Write a post about [topic]. Here are my notes: [bullet points]"
- Review the draft, edit anything that doesn't sound like you

**Collaborative back-and-forth:**
- Write sections you want to write, leave placeholders for the rest
- Ask Claude to fill in specific gaps

### Tips
- Always review before changing `draft: false`
- Tell Claude which mode you want at the start of the session
- If a paragraph doesn't sound like you, say "rewrite this section"

---

## Git Workflow

### Day-to-day

```bash
# Start new work on draft branch
git checkout draft
git pull origin draft

# Write/edit, then commit
git add content/posts/my-post.md
git commit -m "feat: add post about [topic]"
git push origin draft
# → GitHub Actions builds a preview — check the Actions tab for the preview URL

# When happy with the preview:
git checkout main
git merge draft
git push origin main
# → Deploys to takebakker.dev in ~2 minutes
```

### Checking deploy status

GitHub → Actions tab → latest run. Green = success. Click the run for the preview URL (staging environments).

---

## Common Hugo Commands

| Command                          | What it does                                                |
|----------------------------------|-------------------------------------------------------------|
| `hugo server -D`                 | Start local dev server (shows drafts)                       |
| `hugo server`                    | Start local dev server (published only)                     |
| `hugo new posts/slug.md`         | Create new IT post                                          |
| `hugo new gallery/slug/index.md` | Create new gallery album                                    |
| `hugo --minify`                  | Build site to `public/` (done by CI, rarely needed locally) |

---

## Updating the Blowfish Theme

Blowfish is installed as a Git submodule. To update to the latest version:

```bash
git submodule update --remote themes/blowfish
git add themes/blowfish
git commit -m "chore: update Blowfish theme"
git push origin main
```

---

## Custom Domain DNS (Reference)

| Record type      | Name  | Value                                     |
|------------------|-------|-------------------------------------------|
| CNAME (or ALIAS) | `@`   | `[your-swa-hostname].azurestaticapps.net` |
| CNAME            | `www` | `[your-swa-hostname].azurestaticapps.net` |

TLS is managed automatically by Azure Static Web Apps.

---

## Troubleshooting

**Hugo server won't start:** Check `hugo version` — must be Extended edition.

**Theme not loading:** Check that submodules are initialised — run `git submodule update --init --recursive`.

**Gallery images not showing:** Open the blob URL directly in a browser to confirm it's publicly accessible.

**GitHub Actions failing:** Check the Actions tab. Common causes:
- `AZURE_STATIC_WEB_APPS_API_TOKEN` secret not set in GitHub
- Submodules not checked out (workflow uses `submodules: recursive`)

**Terraform errors:** Run `terraform init` first. If state is out of sync, check the Azure Portal to verify what's actually deployed.
