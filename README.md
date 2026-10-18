# Jawaid 4F AI Writing Lab — GitHub Pages

## What is included
- Original 4F learning app with existing embedded LGU logo extracted to `lgu-logo.png`
- Existing editable visual mind map, alongside the four 4F writing stages
- Mobile-responsive navigation, layouts, typography and horizontally scrollable tabs
- Credit: Made by Iqra Iqbal; LGU address and official website link
- Offline device-local drafts, evaluations and progress history
- Optional Supabase email/password student accounts and cloud-synced submissions
- Authenticated teacher dashboard for shared student results, feedback and CSV export

## Deploy to GitHub Pages (free)
1. Make a **public** repository named `USERNAME.github.io` (for root URL) or any project name.
2. Upload the files in this folder directly into the repository root: `index.html`, `lgu-logo.png`, `config.js`. You may also upload the documentation files.
3. **Settings > Pages > Build and deployment**: select `Deploy from a branch`, `main`, `/(root)`, then Save.
4. Open the Pages URL displayed under Settings > Pages. No Colab session is needed.
5. Test on mobile, including 4F paragraph builder, mind map, local save and history.

## Optional free-tier Supabase database + user accounts
1. Create a Supabase project at https://supabase.com. Free-tier limits apply.
2. In Supabase SQL Editor, run **supabase_schema.sql** (only once). For repeated runs, existing policies may need to be dropped first.
3. In Authentication > Providers, enable Email and set appropriate email-verification settings.
4. In Authentication > URL Configuration, set the GitHub Pages URL as Site URL and add its URL to allowed redirect URLs.
5. In Project Settings/API Keys, copy the Project URL and the **publishable or anon key**, NEVER the service_role/secret key.
6. Update `config.js` with those two public values. Commit it to GitHub.
7. Create a teacher user using the app's Student Account UI. Confirm their email if prompted.
8. In Supabase Authentication > Users, copy that account's UUID. In SQL Editor, execute `insert into public.teacher_roles(user_id) values ('TEACHER-USER-UUID');`. Only an administrator should do this.
9. Sign in as a student; save a draft, then select **Sync my saved drafts**. Sign in with the authorized teacher account on another device to see aggregated records.

### Privacy/security notes
- Use anonymous study IDs where possible and obtain necessary institutional consent before collecting student work.
- The public GitHub repo must **never** contain student data, passwords, a Supabase service-role key, or a Gemini API secret.
- Supabase Row Level Security (RLS) protects submitted records. Test student/teacher access before enrolling a class.
- Student sign-in/sync requires internet; unsynced drafts remain only on that device/browser. Clearing browser storage may erase them. Export work regularly.
- Existing 4F scores are formative application results, NOT official IELTS scores.
- GitHub Pages cannot provide a server-side Gemini API proxy. To enable genuine Gemini AI safely, add a separate protected backend. This deployment uses the original offline heuristic feedback mode.
- The teacher's local review UI is for this device's drafts; the new **Cloud teacher review** is for authorized cross-device submissions.
- Logo and brand assets should be used only with appropriate university permissions.
