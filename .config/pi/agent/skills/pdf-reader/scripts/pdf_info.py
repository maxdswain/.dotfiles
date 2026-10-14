#!/usr/bin/env python3
"""PDF metadata and per-page analysis. Run first to triage a PDF."""

import json
import sys

from pdf_data import load


def elements(node):
    """Walk layout elements, including nested table and list content."""
    if isinstance(node, list):
        for child in node:
            yield from elements(child)
    elif isinstance(node, dict):
        if "type" in node:
            yield node
        for key in ("kids", "rows", "cells", "list items"):
            if key in node:
                yield from elements(node[key])


def analyze(path: str) -> dict:
    data, texts = load(path)
    images = [0] * len(texts)
    toc = []
    for item in elements(data.get("kids", [])):
        page = item.get("page number")
        if not isinstance(page, int) or not 1 <= page <= len(texts):
            continue
        if item["type"] == "image":
            images[page - 1] += 1
        elif item["type"] == "heading":
            toc.append({"level": item.get("heading level"), "title": item.get("content", ""), "page": page})

    pages = []
    for i, text in enumerate(texts):
        math_chars = sum(
            1 for c in text
            if ('\u2200' <= c <= '\u22FF') or ('\u2100' <= c <= '\u214F')
            or ('\u2190' <= c <= '\u21FF') or ('\u27C0' <= c <= '\u27EF')
            or ('\u2980' <= c <= '\u29FF') or ('\u2A00' <= c <= '\u2AFF')
            or ('\u0370' <= c <= '\u03FF') or ('\u1D400' <= c <= '\u1D7FF')
        )
        pages.append({
            "page": i + 1,
            "text_length": len(text),
            "image_count": images[i],
            "math_density": round(math_chars / max(len(text), 1), 4),
        })

    return {
        "file": path,
        "page_count": len(texts),
        "title": data.get("title") or "",
        "author": data.get("author") or "",
        "subject": data.get("subject") or "",
        "toc": toc,
        "pages": pages,
    }


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: pdf_info.py <path>", file=sys.stderr)
        sys.exit(1)
    print(json.dumps(analyze(sys.argv[1]), indent=2))
