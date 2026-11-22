<!-- BEGIN shared-doctrine: synced from ~/.dotfiles/agents/AGENTS.md — edit there, run agents-sync -->

# First Principle: Vertical Slices

Every change must deliver end-to-end user value. Never build a layer (schema, API, sync) without the corresponding UI that makes it visible and useful to the user.

- Bad: "Add subtasks table and sync logic" (user sees nothing)
- Good: "Add subtasks that sync from Asana and display as a checklist on the task detail page"

A feature is not done until the user can see it and interact with it. If a story doesn't change what the user experiences, it's not a story. When planning work, always ask: "What will the user see or do differently after this ships?" If you can't answer that, the scope is wrong.

# Subagents and run scope

Ask before spawning subagents. Eager models fan out on their own and each child can inherit the parent's model and reasoning level, so an unasked-for fan-out can burn a large share of a usage window in a single run. When you think a task warrants subagents, propose it and wait — don't spin them up unprompted. (This doesn't apply when I've already asked for orchestration or named a workflow — that's the ask.)

Bound how far a run goes before it checks in. Capable models will happily run a task end-to-end past the point where I'd have wanted to weigh in, and an unbounded run is the most likely way to blow a budget. Prefer clear stop points: finish the plan and stop for feedback before building; complete the bounded chunk and report before taking on the next. When a request has no natural stop point, pick one and say where you're stopping and why, rather than running until you decide you're done.

Both rules above assume a human is in the loop. When running non-interactively — a headless/`-p` run, a cron job, or any context with no one to consult — they don't apply: spawn whatever subagents the task needs and run to completion, since stopping to "ask" or "check in" just deadlocks against a human who isn't there.

# Dev Setup

## Dev logs
If a project runs a long-lived dev server, it should log that server's output to `logs/dev.log` so the agent can read it without running the server. (Skip this for projects with no dev server — static-output builds, one-shot CLIs, libraries.)

Setup (once per project):
```bash
mkdir -p logs && touch logs/dev.log
echo '/logs' >> .gitignore
```

Then wrap the project's actual dev runner — whatever it is — in the shape `truncate -s 0 logs/dev.log && <runner> 2>&1 | tee logs/dev.log`, and wire it into wherever that project launches dev (an npm script, a Rake task, a Makefile target, a Procfile, or just the documented command). The `<runner>` is the real command for the stack, with any proxy/wrapper (portless, ngrok, cloudflared, doppler run, dotenv-cli, foreman, …) kept in front of it:

```bash
next dev                        # Next.js
jekyll serve                    # Jekyll
bin/rails server                # Rails
portless run next dev           # wrapped
```

The `tee` must sit on the outermost command so all wrapper + child output is captured. If a project has a dev server but no logging set up, remind the user.

# Code & Commit Standards
- Only commit working code: typecheck, lint, and tests must pass first.
- Commit messages are one line, no body. Never add AI co-author trailers.
- Commit messages and PR titles/descriptions describe the current state only, as though nothing else will ever change. Never write "temporarily", "for now", "until X", "ahead of the next PR", or a follow-ups section. Plans go in the chat, not in git history.
- Don't write comments explaining code changes; git holds that history.
- Internal services: if/else. External services: try/catch.
- Clickable elements always get `cursor: pointer` / `cursor-pointer`.
- Schema changes go through the project's migration system, never raw SQL.
- Tests never hardcode IDs; assume auto-increment is non-sequential.
- NEVER run or recommend `vercel env pull .env.local` (it overwrites local env). Pull to `.env.production` or back up first.
- New projects: Drizzle for simple apps, Prisma for complex data models. Otherwise use what the project uses.

# Routing
Next.js idioms first; where Next is unopinionated, Rails naming. API: HTTP verbs in `route.js` on `/api/resources[/id]`. Pages: `/resources`, `/resources/new`, `/resources/[id]`, `/resources/[id]/edit`. No `/update`, `/create`, `/view`, `/delete` segments.

<!-- END shared-doctrine -->

# Fantasyspn

A newsletter service for fantasy sports leagues. A commissioner writes posts, which are published to a league page and emailed to the league's owners. It started in 2018 as a single-league app; the plan is multi-league SaaS.

The plan lives in `backlog.md` at the repo root. It's ignored by git, so it isn't in the repo history; read it before starting work and tick items off as they land.

## Stack
- Ruby 2.7.8, Rails 5.2.8.1, Postgres, Redis + Sidekiq, ImageMagick (Active Storage variants)
- Trestle at `/admin` for the admin UI; Redcarpet for markdown; Draper decorators
- Email via ActionMailer: SendGrid in production, letter_opener_web in development
- The backlog's upgrade track takes this to current Rails and Ruby; check `.ruby-version` and the Gemfile rather than assuming

## Running it
- Requires Postgres, Redis and ImageMagick running locally (`brew services start redis`)
- `bin/rails db:setup` creates the dev and test databases and seeds sample data. Seeds are development-only.
- `bin/dev` runs the web server and Sidekiq together and logs to `logs/dev.log`. Read that file for server output instead of starting another server.
- Port: 3000 by default. Set a different one per machine in a gitignored `.env` (`PORT=3009`), or `PORT=xxxx bin/dev`.
- Seed admin: `commish@example.com` / `password` at `/admin`
- Sent emails in development: `/letter_opener`
- Send due posts: `bin/rails send_posts` (production runs this on a schedule)

## Tests
- Minitest: `bin/rails test`. No RSpec.
- Every slice adds tests for what it changes. Fixtures use relative times, never hardcoded IDs.

## Conventions
- Work in vertical slices from `backlog.md`; each one changes what a commissioner or owner sees.
- Branches: `feature/<thing>`, `bug/<thing>` or `chore/<thing>`, naming the thing (e.g. `feature/seasons`).
- Don't add more hardcoded league details: the app is heading to multi-league, so new models should be able to belong to a league later.
- Production `master.key` is never committed; `config/master.key` is gitignored.
