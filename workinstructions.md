# Working Instructions — takebakker.dev Blog

Quick reference for day-to-day blog work. When in doubt, check here first.

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

Opens `content/gallery/album-slug/index.md`. Fill in the `images` list with your CDN URLs (see Photo Upload below).

---

## Uploading Photos to Azure Blob Storage

1. Upload image(s) to the Azure Blob Storage container:

```bash
az storage blob upload \
  --account-name statakebakker \
  --container-name blog-media \
  --name gallery/[album-slug]/[filename].jpg \
  --file "[local path to file]" \
  --content-type image/jpeg
```

2. The public URL will be:
   `https://statakebakker.blob.core.windows.net/blog-media/gallery/[album-slug]/[filename].jpg`

3. Add that URL to the `images` list in your album Markdown file.

**Bulk upload tip (Azure Storage Explorer):** Download Azure Storage Explorer for a GUI drag-and-drop upload experience.

---

## Working with Claude on Posts

### Starting a session
Open a Claude Code session in this repo directory. Claude reads `CLAUDE.md` automatically and will write in your voice.

### Collaboration modes

**You draft, Claude refines:**
- Write your rough notes or a partial draft in `content/drafts/`
- Open Claude Code, say: "Refine this draft into a full post: [paste or reference the file]"

**Claude drafts from your brief:**
- Open Claude Code, say: "Write a post about [topic]. Here are my notes: [bullet points]"
- Review the draft, edit anything that doesn't sound like you

**Collaborative back-and-forth:**
- Write sections you want to write, leave placeholders for the rest
- Ask Claude to fill in specific gaps

### Tips
- Always review before changing `draft: false`
- Tell Claude which mode you want at the start of the session
- If a paragraph doesn't sound like you, say "rewrite this section" — don't accept it as-is

---

## Git Workflow

### Day-to-day

```bash
# Start new work on draft branch
git checkout draft
git pull origin draft

# Do your writing/editing, then commit
git add content/posts/my-post.md
git commit -m "feat: add post about [topic]"
git push origin draft

# Check preview URL (shown in GitHub Actions run or Azure Portal)
# When happy:
git checkout main
git merge draft
git push origin main
# Live in ~2 minutes
```

### Checking deploy status
Go to GitHub → Actions tab → latest run. Green = success.

---

## Common Hugo Commands

| Command | What it does |
|---|---|
| `hugo server -D` | Start local dev server (shows drafts) |
| `hugo server` | Start local dev server (published only) |
| `hugo new posts/slug.md` | Create new IT post |
| `hugo new gallery/slug/index.md` | Create new gallery album |
| `hugo --minify` | Build site to `public/` (done by CI, rarely needed locally) |
| `hugo mod tidy` | Clean up go module dependencies |

---

## Updating the Blowfish Theme

```bash
hugo mod get -u github.com/nunocoracao/blowfish
hugo mod tidy
git add go.mod go.sum
git commit -m "chore: update Blowfish theme"
git push origin main
```

---

## Custom Domain DNS (Reference)

If DNS needs to be reconfigured:

| Record type | Name | Value |
|---|---|---|
| CNAME (or ALIAS) | `@` | `[your-swa-hostname].azurestaticapps.net` |
| CNAME | `www` | `[your-swa-hostname].azurestaticapps.net` |

TLS is managed automatically by Azure Static Web Apps.

---

## Troubleshooting

**Hugo server won't start:** Check `hugo version` — must be Extended edition.

**Theme not loading:** Run `hugo mod get github.com/nunocoracao/blowfish` and restart the server.

**Gallery images not showing:** Check the blob storage URL is publicly accessible — open it directly in a browser.

**GitHub Actions failing:** Check the Actions tab for error details. Most common cause: `app_build_command` not set to `hugo --minify`.
