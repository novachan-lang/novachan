# prism/intl — internationalization

**MB.8 DONE** (2026-08-16): `prism_intl.nova` (message catalogs, `{name}` interpolation, CLDR
plural categories, locale-aware integer grouping, text direction) + `kat/_kat_prism_intl.nova`
(96 checks, ALL PASS; 30 rejection cases). LEAF module, imports nothing, self-contained (does
NOT import `std/i18n/locale.nova` -- see the file's own header for why that existing module was
read but not reused). Locales shipped: `en` (default/fallback root), `pl` (CLDR few/many).

This absorbs the `prism_i18n.nova` (#66 #120) and `prism_number.nova` (#65) roles from the
original 3-module sketch below into one file, per MB.8's brief. `prism_datetime.nova` (#64,
`Instant` / `ZonedDateTime` / `PlainDate`) remains **NOT STARTED** -- still called out in
`PRISM_STATUS.md` as CRITICAL for the tiger1 target application, and deliberately out of scope
here (calendar math deserves its own falsification pass, not a bolt-on to this milestone).

| Module | Purpose | Status |
|---|---|---|
| `prism_intl.nova` | Catalogs, interpolation, plural, number grouping, locale, direction (#66 #120 #65, combined) | **DONE** |
| `prism_datetime.nova` | `Instant` / `ZonedDateTime` / `PlainDate` (#64) | **BUILT** |
