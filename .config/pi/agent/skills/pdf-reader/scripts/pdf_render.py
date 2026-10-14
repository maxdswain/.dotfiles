#!/usr/bin/env python3
"""Render PDF pages to PNG using Poppler's pdfinfo and pdftoppm."""

import argparse
import hashlib
import re
import subprocess
from pathlib import Path

from pdf_data import parse_pages


def render(path: str, page_spec: str = "all", dpi: int = 150) -> list[str]:
    source = Path(path).resolve()
    info = subprocess.run(["pdfinfo", str(source)], check=True, capture_output=True, text=True)
    match = re.search(r"^Pages:\s*(\d+)\s*$", info.stdout, re.MULTILINE)
    if not match:
        raise ValueError("Could not determine PDF page count from pdfinfo")
    if dpi <= 0:
        raise ValueError("DPI must be positive")

    file_hash = hashlib.md5(str(source).encode()).hexdigest()[:10]
    out_dir = Path("/tmp") / f"pi-pdf-{file_hash}"
    out_dir.mkdir(parents=True, exist_ok=True)

    paths = []
    for i in parse_pages(page_spec, int(match.group(1))):
        output = out_dir / f"page_{i + 1:04d}"
        subprocess.run(
            ["pdftoppm", "-f", str(i + 1), "-l", str(i + 1), "-singlefile", "-r", str(dpi), "-png", str(source), str(output)],
            check=True,
        )
        path = str(output.with_suffix(".png"))
        paths.append(path)
        print(f"Page {i + 1} -> {path}")
    return paths


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Render PDF pages to PNG")
    parser.add_argument("path", help="Path to PDF file")
    parser.add_argument("--pages", default="all", help="Page range: 'all', '1-5', '1,3,7', '3'")
    parser.add_argument("--dpi", type=int, default=150, help="Render resolution (default: 150)")
    args = parser.parse_args()
    render(args.path, args.pages, args.dpi)
