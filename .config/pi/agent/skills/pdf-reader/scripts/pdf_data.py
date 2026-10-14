"""OpenDataLoader PDF conversion shared by the info, extract, and search scripts."""

import json
import tempfile
from pathlib import Path

import opendataloader_pdf


SEPARATOR = "\n__PI_PDF_PAGE_BOUNDARY__\n"


def load(path: str) -> tuple[dict, list[str]]:
    """Convert a PDF once and return its metadata/layout and page-separated text."""
    source = Path(path).resolve()
    with tempfile.TemporaryDirectory(prefix="pi-pdf-data-") as directory:
        opendataloader_pdf.convert(
            input_path=str(source),
            output_dir=directory,
            format="json,text",
            text_page_separator=SEPARATOR,
            image_output="off",
            quiet=True,
        )
        base = Path(directory) / source.stem
        data = json.loads(base.with_suffix(".json").read_text(encoding="utf-8"))
        text = base.with_suffix(".txt").read_text(encoding="utf-8")

    count = data["number of pages"]
    pages = text.split(SEPARATOR)
    # OpenDataLoader currently emits the separator before each page, including page 1.
    # Accept both that behavior and a separator strictly between pages.
    if len(pages) == count + 1 and not pages[0].strip():
        pages = pages[1:]
    if len(pages) != count:
        raise ValueError(f"Expected {count} pages, but OpenDataLoader returned {len(pages)} text segments")
    return data, [page.strip("\r\n") for page in pages]


def parse_pages(spec: str, total: int) -> list[int]:
    """Parse 'all', '1-5', '1,3,7', or '3' into 0-indexed page numbers."""
    if spec.strip().lower() == "all":
        return list(range(total))

    pages = set()
    for part in spec.split(","):
        part = part.strip()
        if "-" in part:
            start, end = part.split("-", 1)
            start = max(1, int(start))
            end = min(total, int(end))
            pages.update(range(start - 1, end))
        else:
            p = int(part) - 1
            if 0 <= p < total:
                pages.add(p)
    return sorted(pages)
