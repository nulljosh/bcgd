# Bcgd Roadmap

## From Bcgd.pdf (imported 2026-07-19)
- [ ] Identified source site (2026-07-20): **bcgaragedoors.ca** (Best Choice Garage Doors) — confirmed via README.md/WHITEPAPER.md, already the basis for `web/` (landing page). User wants closer 1:1 replication, not just a style reference. Still open: full page-by-page clone pass (content, copy, layout sections) — full scrape/clone not attempted this session, scoped as its own task.

## Ingested 2026-07-25
- [ ] Compare bcgd.heyitsmejosh.com against source site bcgaragedoors.ca — identify missing components, build a design system synthesizing both. Attempted 2026-07-26: `curl` against `bcgaragedoors.ca` returns empty body (likely bot-protected or JS-rendered) — a static fetch can't do this comparison. Needs a real browser render (confirm before opening Chrome) or a manual pass; genuinely open-ended design work, not a quick diff.
