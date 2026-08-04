# Claude in Chrome Operation Tips

## Form Input Basic Policy

- Use `read_page(filter="interactive")` first to understand the form structure and ref_ids.
- Set all fields that `form_input` can handle in a single batch.
- For fields where `form_input` doesn't work (SPA comboboxes, fields requiring candidate selection, etc.), use ref-based `left_click` + `type` + candidate selection (or `key` for Enter/Tab).
- Never use coordinate-based clicks; always operate via ref.
- Keep screenshots to a minimum (only for confirming input content and completion).
