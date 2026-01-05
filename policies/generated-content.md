# Generated Content Policy

When and how to generate documentation from structured sources.

## Default: Handwritten

**Start with handwritten documentation.** Only generate when you have clear, repeated pain.

Generation adds complexity:
- Maintenance of generation scripts
- Build/regeneration workflows
- Potential for drift between source and output
- Debugging when generation breaks

Generate only when the pain of manual maintenance exceeds the cost of automation.

## Pain Triggers for Generation

### Synchronization Pain

**Signals:**
- Same information exists in multiple places (code + docs)
- Frequent out-of-sync errors between source and docs
- Manual updates needed every code change
- Documentation errors from stale manual copies

**Example:**
- API function signatures change → docs must be manually updated
- CLI command options added → reference must be manually updated
- Database schema evolves → docs lag behind

**Threshold:** Weekly sync burden, or errors from staleness

**Solution:** Extract from source of truth

### Scale Pain

**Signals:**
- Manual indexing becomes burdensome (50+ documents)
- Consistent formatting errors across large doc sets
- Time spent on mechanical organization > time on content
- Navigation structures hard to maintain manually

**Example:**
- 30+ ADRs need index table with status, date, links
- 100+ API endpoints need consistent reference format
- Large codebase needs maintained file structure overview

**Threshold:** >1 hour/week on mechanical maintenance

**Solution:** Generate indexes, tables, navigation

### Consistency Pain

**Signals:**
- Same structure repeated many times with small variations
- Human formatting errors in repeated patterns
- Style inconsistencies across similar documents
- Copy-paste errors in boilerplate

**Example:**
- CLI commands all documented with same structure
- API endpoints all need same sections (params, response, errors)
- Component docs all follow same template

**Threshold:** Errors in consistency, or significant time on formatting

**Solution:** Generate from structured source + template

## Generation Levels

Ordered by increasing complexity:

### Level 1: Generated Indexes

**What:** Generate tables of contents, indexes, or navigation from existing content

**Source:** Existing markdown files (read frontmatter, headings)

**Output:** Index markdown, navigation tables, cross-reference lists

**Examples:**
- ADR index table from frontmatter
- Documentation map from file structure
- Tag-based topic index from metadata

**Characteristics:**
- Low risk (doesn't touch source content)
- Easy to maintain (simple scripts)
- Reversible (can go back to manual)
- Content remains handwritten

**When to use:**
- 20+ documents needing organized navigation
- Frequent additions making manual indexes burdensome

**Example script:**
```python
# scripts/generate-adr-index.py
# Reads docs/decisions/*.md frontmatter
# Outputs table in docs/decisions/README.md
```

### Level 2: Extracted Summaries

**What:** Extract from source (code) and render in documentation context

**Source:** Code annotations, docstrings, type signatures, decorators

**Output:** Reference documentation with source-extracted content

**Examples:**
- CLI reference from Typer/Click decorators
- API reference from docstrings
- Configuration reference from schema definitions

**Characteristics:**
- Medium risk (derived from code, can get complex)
- Moderate maintenance (scripts can break with code changes)
- High value (always in sync with code)
- Combines generated + handwritten (examples, guides)

**When to use:**
- API/CLI with >10 operations
- Code is source of truth for structure
- Manual sync burden is weekly+

**Example pattern:**
```markdown
<!-- Handwritten intro -->
## CLI Commands

This reference documents all available commands.

<!-- AUTO-GENERATED START -->
<!-- Source: scripts/generate-cli-docs.py from src/cli/*.py -->

### command-name

Description from docstring...

**Options:**
- `--option` - From decorator annotations

<!-- AUTO-GENERATED END -->

<!-- Handwritten examples -->
## Common Workflows
...
```

### Level 3: Fully Generated Documents

**What:** Entire documents generated from structured sources

**Source:** Code, schemas, databases, external APIs

**Output:** Complete markdown documents

**Examples:**
- Full API reference from OpenAPI spec
- Database schema docs from SQL definitions
- Component catalog from code analysis

**Characteristics:**
- High risk (complex generation, many failure modes)
- High maintenance (generation logic can be complex)
- Highest value when source is complex
- Human edits require separate overlay files

**When to use:**
- Source is definitive and complex
- Manual documentation is impossible (too large/complex)
- Structure is highly regular and machine-readable

**Example:**
```markdown
<!-- docs/api-reference.md -->
<!-- FULLY AUTO-GENERATED -->
<!-- Source: openapi-spec.yaml -->
<!-- Generator: scripts/generate-api-docs.py -->
<!-- Last generated: 2026-01-05 12:34 -->
<!-- DO NOT EDIT: Changes will be overwritten -->

# API Reference

[Entire content generated from spec]
```

## Mark Generated Content

Always clearly mark what's generated:

### Inline Markers

```markdown
<!-- AUTO-GENERATED: Do not edit this section directly -->
<!-- Source: scripts/generate-cli-docs.py from src/cli/commands/*.py -->
<!-- Generated: 2026-01-05 12:34:56 -->

[Generated content here]

<!-- END AUTO-GENERATED -->
```

### Full Document Markers

```markdown
---
generated: true
source: scripts/generate-docs.py
last_generated: 2026-01-05T12:34:56
do_not_edit: true
---

<!-- FULLY AUTO-GENERATED -->
<!-- Any manual edits will be overwritten on next generation -->

# Document Title

[All content generated]
```

### Frontmatter Markers

```yaml
---
status: stable
generated:
  enabled: true
  script: scripts/generate-api-docs.py
  source: src/api/*.py
  last_run: 2026-01-05T12:34:56
  partial: true  # or false for fully generated
  sections: ["## API Endpoints"]  # which sections are generated
---
```

## Separate Generated from Handwritten

### Pattern 1: Sections

Handwritten narrative, generated reference:

```markdown
# User Guide (handwritten)

## Getting Started

[Handwritten tutorial]

## API Reference (generated)

<!-- AUTO-GENERATED -->
[Extracted from code]
<!-- END AUTO-GENERATED -->

## Examples (handwritten)

[Handwritten examples]
```

### Pattern 2: Files

Separate files for generated vs. handwritten:

```
docs/
├── user-guide.md           # Handwritten
├── tutorials/              # Handwritten
│   └── *.md
├── api-reference.md        # AUTO-GENERATED
└── examples/               # Handwritten
    └── *.md
```

### Pattern 3: Overlays

Generated base + handwritten overlays:

```
docs/
├── api/
│   ├── _generated/         # Fully generated (gitignored or committed)
│   │   └── endpoints.md
│   ├── overlays/           # Handwritten enhancements
│   │   └── endpoint-examples.md
│   └── README.md           # Includes both
```

## Maintain the Boundary

### What to Generate

- **Structure:** Tables, lists, indexes
- **Data:** Signatures, types, parameters, return values
- **Boilerplate:** Repeated patterns
- **Cross-references:** Links between related items

### What to Handwrite

- **Concepts:** Why, when, how to use
- **Examples:** Real-world usage patterns
- **Guidance:** Best practices, common pitfalls
- **Context:** Historical decisions, tradeoffs

### Example Split

**Generated (from code):**
```markdown
### create_user

`create_user(name: str, email: str) -> User`

**Parameters:**
- `name` (str): User's full name
- `email` (str): User's email address

**Returns:** User object

**Raises:**
- `ValidationError`: Invalid email format
```

**Handwritten (concepts):**
```markdown
**When to use:** Create user accounts during signup or admin operations.

**Example:**
```python
user = create_user(
    name="Alice Smith",
    email="alice@example.com"
)
```

**Best practice:** Always validate email before calling. See [validation guide](../guides/validation.md).
```

## Version Control

### Commit Generated Docs

**Recommendation:** Commit generated documentation to git

**Rationale:**
- Diffs show what changed in generated output
- History preserves documentation evolution
- No build step required to read docs
- Easy to review pull requests

**Exception:** Very large generated docs (>1MB) may be gitignored

### Include Generation Script

Always version control:
- Generation scripts (`scripts/generate-*.py`)
- Templates (`templates/*.md`)
- Configuration for generation
- README documenting how to regenerate

### Document Regeneration

In README or contributing guide:

```markdown
## Regenerating Documentation

Some documentation is auto-generated from source code:

**Generated files:**
- `docs/cli-reference.md` - from `src/cli/commands/*.py`
- `docs/api/endpoints.md` - from `src/api/*.py`

**Regeneration:**
```bash
# Regenerate all
./scripts/generate-docs.sh

# Or individually
python scripts/generate-cli-docs.py
python scripts/generate-api-docs.py
```

**When to regenerate:**
- After adding/modifying CLI commands
- After changing API endpoints
- Before committing if source changed
- CI/CD checks that generated docs are current
```

### CI Validation

Verify generated docs are up to date:

```yaml
# .github/workflows/ci.yml
- name: Check generated docs are current
  run: |
    ./scripts/generate-docs.sh
    git diff --exit-code docs/
    # Fails if generated docs were stale
```

## Generation Patterns

### Pattern 1: Frontmatter Extraction

**Use case:** Generate indexes from document metadata

```python
# scripts/generate-adr-index.py
import yaml
from pathlib import Path

docs = Path("docs/decisions").glob("*.md")
for doc in sorted(docs):
    content = doc.read_text()
    if content.startswith("---"):
        _, fm, _ = content.split("---", 2)
        meta = yaml.safe_load(fm)
        print(f"| {meta['title']} | {meta['status']} | {meta['date']} |")
```

### Pattern 2: Docstring Extraction

**Use case:** API reference from Python docstrings

```python
# scripts/generate-api-docs.py
import ast, inspect

def extract_function_doc(func):
    sig = inspect.signature(func)
    doc = inspect.getdoc(func)
    return {
        'name': func.__name__,
        'signature': str(sig),
        'docstring': doc
    }

# Generate markdown from extracted data
```

### Pattern 3: Decorator Analysis

**Use case:** CLI reference from Click/Typer decorators

```python
# scripts/generate-cli-docs.py
from typer import Typer
from typer.models import CommandInfo

app = Typer()
# Import your CLI app

for command in app.registered_commands:
    print(f"### {command.name}")
    print(f"{command.help}")
    # Extract options from command.params
```

### Pattern 4: Template Rendering

**Use case:** Consistent structure for many items

```python
# scripts/generate-from-template.py
from jinja2 import Template

template = Template("""
### {{ name }}

{{ description }}

**Parameters:**
{% for param in parameters %}
- `{{ param.name }}` ({{ param.type }}): {{ param.desc }}
{% endfor %}
""")

rendered = template.render(name="...", description="...", parameters=[...])
```

## Best Practices

### Start Small

1. Identify one painful manual task
2. Write minimal generation script
3. Test on small subset
4. Iterate until reliable
5. Apply to full set
6. Add CI validation

### Keep Scripts Simple

- Single purpose per script
- Clear input/output
- Fail loudly on errors
- Document assumptions

### Make Regeneration Easy

```bash
# Single command regenerates everything
./scripts/generate-docs.sh

# Or use task runner
task docs:generate
```

### Test Generated Output

```python
# tests/test_doc_generation.py
def test_cli_docs_generation():
    """Verify generated CLI docs are valid markdown."""
    generate_cli_docs()
    assert Path("docs/cli-reference.md").exists()
    # Validate structure, links, etc.
```

## Anti-Patterns

**Avoid:**

❌ **Generating before you have manual version** - Write manually first, understand the pattern

❌ **Complex generation logic** - If script is >200 lines, reconsider

❌ **No markers** - Always mark what's generated

❌ **Editing generated content** - Edit source or overlay, not generated output

❌ **Generation without validation** - CI should catch stale generated docs

❌ **Over-generating** - Don't generate what's easy to maintain manually

## Related

- [Authority policy](authority.md) - Generated docs are derived, not canonical
- [Lifecycle policy](lifecycle.md) - Generated docs follow source lifecycle
- [UI views strategy](../docs/strategies/ui-views.md) - Generation as views over data

## Examples

**Good generation candidates:**
- CLI reference with 20+ commands
- API with 50+ endpoints
- ADR index from 30+ decisions
- File structure overview for large codebase

**Poor generation candidates:**
- 3 API endpoints (just write manually)
- Single architecture doc
- Small config file (document by hand)
- Conceptual guides (need human judgment)
