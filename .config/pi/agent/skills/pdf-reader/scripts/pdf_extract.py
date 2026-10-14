#!/usr/bin/env python3
"""Extract text from PDF pages using OpenDataLoader PDF."""

import argparse

from pdf_data import load, parse_pages


def extract(path: str, page_spec: str = "all") -> None:
    _, texts = load(path)
    for i in parse_pages(page_spec, len(texts)):
        print(f"--- Page {i + 1} ---")
        print(texts[i])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract text from PDF")
    parser.add_argument("path", help="Path to PDF file")
    parser.add_argument("--pages", default="all", help="Page range: 'all', '1-5', '1,3,7', '3'")
    args = parser.parse_args()
    extract(args.path, args.pages)
