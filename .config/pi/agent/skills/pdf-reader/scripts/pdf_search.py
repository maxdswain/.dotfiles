#!/usr/bin/env python3
"""Search OpenDataLoader-extracted PDF text by keyword or regex."""

import argparse
import re

from pdf_data import load


def search(path: str, query: str, context_lines: int = 3, literal: bool = False) -> None:
    pattern = re.compile(re.escape(query) if literal else query, re.IGNORECASE)
    _, texts = load(path)
    total_matches = 0

    for i, text in enumerate(texts):
        lines = text.splitlines()
        for line_num, line in enumerate(lines):
            if pattern.search(line):
                total_matches += 1
                print(f"\n=== Page {i + 1}, line {line_num + 1} ===")
                start = max(0, line_num - context_lines)
                end = min(len(lines), line_num + context_lines + 1)
                for j in range(start, end):
                    marker = ">>>" if j == line_num else "   "
                    print(f"{marker} {lines[j]}")

    if total_matches == 0:
        print(f"No matches found for: {query}")
    else:
        print(f"\n--- {total_matches} match(es) found ---")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Search within PDF text")
    parser.add_argument("path", help="Path to PDF file")
    parser.add_argument("query", help="Search query (regex or literal)")
    parser.add_argument("--context", type=int, default=3, help="Context lines around match (default: 3)")
    parser.add_argument("--literal", action="store_true", help="Treat query as literal string")
    args = parser.parse_args()
    search(args.path, args.query, args.context, args.literal)
