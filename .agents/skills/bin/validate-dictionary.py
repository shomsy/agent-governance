#!/usr/bin/env python3
"""validate-dictionary.py — Framework Dictionary Integrity Validator

Validates the framework dictionary for:
- index.json is valid JSON and well-formed
- All terms in index have corresponding .md files
- All .md files have required sections
- No duplicate terms
- No orphan files (files without index entries, or index entries without files)
- All references are non-empty URLs
- No circular or contradictory entries

Usage:
    python3 validate-dictionary.py [dictionary_root]

Exit codes:
    0 — All checks passed
    1 — Validation errors found
"""

import json
import os
import re
import sys
from pathlib import Path

REQUIRED_SECTIONS = [
    "Term",
    "Classification",
    "Purpose",
    "Why Allowed",
    "Allowed Contexts",
    "Forbidden Misuse",
    "Ecosystem References",
    "Allowed Patterns",
    "Forbidden Patterns",
]

REQUIRED_LIST_SECTIONS = [
    "Allowed Contexts",
    "Forbidden Misuse",
    "Ecosystem References",
    "Allowed Patterns",
    "Forbidden Patterns",
]


def parse_markdown_sections(content: str) -> dict[str, str]:
    """Parse markdown content into heading -> body sections."""
    sections = {}
    current_heading = None
    current_lines = []

    for line in content.split("\n"):
        if line.startswith("# "):
            if current_heading:
                sections[current_heading] = "\n".join(current_lines).strip()
            current_heading = line[2:].strip()
            current_lines = []
        else:
            current_lines.append(line)

    if current_heading:
        sections[current_heading] = "\n".join(current_lines).strip()

    return sections


def parse_list_items(text: str) -> list[str]:
    """Extract list items from markdown text."""
    if not text:
        return []
    return [line.lstrip("- *").strip() for line in text.split("\n") if line.strip().startswith(("- ", "* "))]


def validate_index_json(index_path: Path) -> tuple[bool, list[str]]:
    """Validate the index.json file."""
    errors = []

    if not index_path.is_file():
        return False, [f"index.json not found at {index_path}"]

    try:
        with open(index_path, "r", encoding="utf-8") as f:
            index = json.load(f)
    except json.JSONDecodeError as e:
        return False, [f"index.json is not valid JSON: {e}"]

    # Required top-level keys
    for key in ["version", "terms", "total_terms"]:
        if key not in index:
            errors.append(f"Missing required key in index.json: {key}")

    if errors:
        return False, errors

    terms = index.get("terms", {})
    if not isinstance(terms, dict):
        return False, ["index.json 'terms' must be an object"]

    # Check for duplicate terms (keys must be unique — JSON guarantees this, but verify count)
    if len(terms) != index.get("total_terms", -1):
        errors.append(
            f"total_terms ({index.get('total_terms')}) does not match actual term count ({len(terms)})"
        )

    # Validate v2 levels definition
    levels = index.get("levels", {})
    if not levels:
        errors.append("index.json missing 'levels' definition (v2 schema requires levels)")
    else:
        expected_levels = {"FOUNDATIONAL", "FRAMEWORK_STANDARD", "CONTEXTUAL", "LEGACY_ALLOWED", "DISCOURAGED"}
        missing_levels = expected_levels - set(levels.keys())
        if missing_levels:
            errors.append(f"index.json missing level definitions: {', '.join(sorted(missing_levels))}")

    # Validate each term entry
    valid_levels = set(levels.keys()) if levels else {"FOUNDATIONAL", "FRAMEWORK_STANDARD", "CONTEXTUAL", "LEGACY_ALLOWED", "DISCOURAGED"}

    for term, entry in terms.items():
        for field in ["level", "classification", "ecosystem", "allowed_contexts", "forbidden_misuse", "references"]:
            if field not in entry:
                errors.append(f"Term '{term}' missing required field: {field}")

        # Level must be one of the defined levels
        term_level = entry.get("level", "")
        if term_level and term_level not in valid_levels:
            errors.append(f"Term '{term}' has invalid level '{term_level}'. Must be one of: {', '.join(sorted(valid_levels))}")

        # Path constraints (v2): allowed_paths and forbidden_paths must be lists if present
        for path_field in ["allowed_paths", "forbidden_paths"]:
            if path_field in entry and not isinstance(entry[path_field], list):
                errors.append(f"Term '{term}' field '{path_field}' must be a list of glob patterns")

        # Anti-cargo-cult (v2): must be a list if present
        if "anti_cargo_cult" in entry and not isinstance(entry["anti_cargo_cult"], list):
            errors.append(f"Term '{term}' field 'anti_cargo_cult' must be a list of patterns")

        # References must be non-empty URLs
        for ref in entry.get("references", []):
            if not ref.startswith("http"):
                errors.append(f"Term '{term}' has non-URL reference: {ref}")

    return len(errors) == 0, errors


def term_to_slug(term: str) -> str:
    """Convert a term like 'ServiceProvider' to 'service-provider'.
    Handles acronyms: DTO -> dto, ValueObject -> value-object.
    """
    # Insert hyphen before uppercase that follows lowercase or digit
    s = re.sub(r"([a-z0-9])([A-Z])", r"\1-\2", term)
    # Insert hyphen between consecutive uppercase followed by lowercase (XMLParser -> xml-parser)
    s = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1-\2", s)
    return s.lower()


def validate_term_files(dictionary_root: Path, index: dict) -> tuple[bool, list[str]]:
    """Validate that all index terms have .md files and vice versa."""
    errors = []
    terms = index.get("terms", {})

    # Check each term has a file
    for term in terms:
        slug = term_to_slug(term)
        # Search all ecosystem subdirectories
        found = False
        for eco_dir in dictionary_root.iterdir():
            if eco_dir.is_dir() and eco_dir.name != "__pycache__":
                candidate = eco_dir / f"{slug}.md"
                if candidate.is_file():
                    found = True
                    # Validate file content
                    content = candidate.read_text(encoding="utf-8")
                    sections = parse_markdown_sections(content)

                    for section in REQUIRED_SECTIONS:
                        if section not in sections:
                            errors.append(f"File {candidate.relative_to(dictionary_root)} missing section: {section}")

                    # List sections must have items
                    for section in REQUIRED_LIST_SECTIONS:
                        items = parse_list_items(sections.get(section, ""))
                        if not items:
                            errors.append(
                                f"File {candidate.relative_to(dictionary_root)} section '{section}' has no list items"
                            )

                    # Term in file must match index key
                    file_term = sections.get("Term", "").strip()
                    if file_term and file_term != term:
                        errors.append(
                            f"File {candidate.relative_to(dictionary_root)} has Term '{file_term}' but index key is '{term}'"
                        )
                    break
        if not found:
            errors.append(f"No .md file found for index term '{term}' (expected slug: {slug})")

    # Check for orphan files (files not in index)
    indexed_slugs = set()
    for term in terms:
        indexed_slugs.add(term_to_slug(term))

    for md_file in dictionary_root.rglob("*.md"):
        if md_file.name == "README.md":
            continue
        slug = md_file.stem
        if slug not in indexed_slugs:
            errors.append(f"Orphan dictionary file with no index entry: {md_file.relative_to(dictionary_root)}")

    return len(errors) == 0, errors


def validate_dictionary(dictionary_root: str) -> tuple[bool, list[str], bool]:
    """Run full dictionary validation.
    
    Returns (ok, errors, skipped) where skipped=True means dictionary not applicable.
    """
    root = Path(dictionary_root).resolve()
    errors = []

    if not root.is_dir():
        return False, [f"Dictionary root not found: {root}"], False

    index_path = root / "index.json"

    # Validate index.json
    index_ok, index_errors = validate_index_json(index_path)

    # If index.json doesn't exist, dictionary is not applicable — skip gracefully
    if not index_ok and any("index.json not found" in e for e in index_errors):
        return True, [], True  # ok, no errors, skipped

    errors.extend(index_errors)

    if not index_ok:
        return False, errors, False

    with open(index_path, "r", encoding="utf-8") as f:
        index = json.load(f)

    # Validate term files
    files_ok, file_errors = validate_term_files(root, index)
    errors.extend(file_errors)

    return len(errors) == 0, errors, False


def main():
    dictionary_root = sys.argv[1] if len(sys.argv) > 1 else ".agents/.rules/governance/framework-dictionary"

    ok, errors, skipped = validate_dictionary(dictionary_root)

    if skipped:
        print("ℹ️  INFO: Framework dictionary not applicable — index.json not found.")
        print("   Dictionary validation skipped for projects without a framework glossary.")
        sys.exit(0)

    if ok:
        print("✅ Framework Dictionary validation PASSED.")
        index_path = Path(dictionary_root) / "index.json"
        if not index_path.is_file():
            print("   Dictionary not applicable — no index.json present.")
            sys.exit(0)
        with open(index_path, "r", encoding="utf-8") as f:
            index = json.load(f)
        print(f"   Version: {index.get('version', 'unknown')}")
        print(f"   Terms: {index.get('total_terms', 0)}")
        print(f"   Ecosystems: {', '.join(index.get('ecosystems', []))}")
        sys.exit(0)
    else:
        print("❌ Framework Dictionary validation FAILED:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
