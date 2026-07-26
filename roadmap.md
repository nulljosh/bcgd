# Bcgd Roadmap

## From Bcgd.pdf (imported 2026-07-19)
- [ ] Identified source site (2026-07-20): **bcgaragedoors.ca** (Best Choice Garage Doors) — confirmed via README.md/WHITEPAPER.md, already the basis for `web/` (landing page). User wants closer 1:1 replication, not just a style reference. Still open: full page-by-page clone pass (content, copy, layout sections) — full scrape/clone not attempted this session, scoped as its own task.

## Ingested 2026-07-25
- [ ] Compare bcgd.heyitsmejosh.com against source site bcgaragedoors.ca — identify missing components, build a design system synthesizing both.
- [x] Footer text not very legible — fix contrast/styling. Done 2026-07-25: root cause was the footer's dark teal (#134040) background inheriting the light-theme text tokens (#5c6266/#868c95, ~2:1). Scoped light-on-dark `--text-*`/`--apple-blue` overrides onto `.footer` in `src/web/index.html` (all 5.5–11.4:1, AA verified) + bumped the `.footer-bottom` divider to 0.16 alpha.
